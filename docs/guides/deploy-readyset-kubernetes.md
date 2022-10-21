# Deploy ReadySet with Kubernetes

This page shows you how to run ReadySet on [Amazon EKS](https://aws.amazon.com/eks/) in front of an [Amazon RDS](https://aws.amazon.com/rds/) for Postgres or MySQL database.

First, you'll start a Kubernetes cluster on Amazon EKS with enough resources for a simple ReadySet deployment. For efficient networking and security, you'll use the same VPC as your database. Next, you'll set up load balancing to handle traffic from outside of the Kubernetes cluster. Then you'll configure your database to ensure that ReadySet can consume the database's replication stream. Finally, you'll use ReadySet's Helm chart to deploy ReadySet into the Kubernetes cluster.

## Before you begin

- Make sure you have an existing [Amazon RDS for Postgres](https://aws.amazon.com/rds/postgresql/) or [Amazon RDS for MySQL](https://aws.amazon.com/rds/mysql/) database.

    ReadySet can be run in front of other versions of Postgres and MySQL. However, this tutorial focuses on RDS.

- Make sure there are no DDL statements in progress.

    ReadySet will take an initial snapshot of your data. Until the entire snapshot is finished, which can take between a few minutes to several hours depending on the size of your dataset, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked. In MySQL, `INSERT` and `UPDATE` statements will also be blocked, but only while a given table is being snapshotted.

- Complete the steps described in the [EKS Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) documentation.

    This includes installing and configuring `eksctl`, the command-line tool for creating and deleting Kubernetes clusters on EKS, and `kubectl`, the command-line tool for managing Kubernetes from your workstation.

- For efficient networking and security, you'll deploy your Kubernetes cluster into the same VPC as your database. Make sure you meet the [EKS requirements for using an existing VPC](https://eksctl.io/usage/vpc-configuration/#use-existing-vpc-other-custom-configuration).  

## Step 1. Start Kubernetes

In this step, you'll create a Kubernetes cluster on Amazon EKS in the same VPC as your database. Your cluster will contain 3 nodes to accommodate a simple ReadySet deployment of one ReadySet Server, one ReadySet Adapter, and one instance of Consul.(1)
{ .annotate }

1.  - The ReadySet Server makes a copy of your underlying database, listens to the database's replication stream for updates, and keeps queries cached in an in-memory dataflow graph.
      - The ReadySet Adapter handles connections from SQL clients and ORMs, forwarding uncached queries upstream and running cached queries against the ReadySet Server.
      - Consul handles internal cluster state.

For more demanding workloads, ReadySet can be run with multiple Adapters. Please [reach out](mailto:info@readyset.io) to ReadySet for guidance.

1. Identify the subnets in your database's VPC:

    1. In the RDS Console, select your database.
    2. Under **Connectivity & security**, note the **Subnets**.

2. From your local workstation, create a Kubernetes cluster, replacing the `<db-subnet>` placeholders with the subnets from the previous step:

    ``` sh
    eksctl create cluster \
    --name=readyset \
    --region=us-east-1 \
    --nodegroup-name=standard-workers \
    --nodes=3 \
    --node-type=c5.2xlarge \
    --node-private-networking \
    --vpc-private-subnets=<db-subnet1>,<db-subnet2>,<db-subnet3>,...
    ```

    | Flag | Description                          |
    | -----| ------------------------------------ |
    | `--name` | The name of the cluster.  |
    | `--region` | The [region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) to deploy the cluster in. |
    | `--nodegroup-name` | The name of the pool of nodes for the cluster. |
    | `--nodes` | <p>The number of nodes in the cluster.</p><p>3 is the minimum required for a simple ReadySet deployment of one ReadySet Server, one ReadySet Adapter, and one instance of Consul.</p> |
    | `--node-type` | <p>The [instance type](https://www.amazonaws.cn/en/ec2/instance-types/) to use for the nodes.</p><p>The `c5.2xlarge` type is fine for testing ReadySet; however, ReadySet is a memory-intensive application, so you should use memory-optimized instances (`r5.2xlarge` or larger) for production deployments.</p> |
    | `--vpc-private-subnets` | <p>The subnets of your database's VPC.</p><p>If you do not want to create the cluster in the same VPC as your database (e.g., you plan to set up [VPC peering](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-peering.html) between Kubernetes and the database), remove this flag and `--node-private-networking`.   |

    Cluster provisioning usually takes between 10 and 15 minutes. Do not move on to the next step until you see a message like `[✔] EKS cluster "readyset" in "us-east-1" region is ready` and details about your cluster.

3. Check that you can connect to the database from your EKS cluster.

    === "RDS Postgres"

        1. In your EKS cluster, create a temporary pod containing the `psql` client:

            ``` sh
            kubectl run rs-postgres-client \
            --rm --tty -i \
            --restart='Never' \
            --image=postgres \
            --namespace=default \
            --command -- bash
            ```

        2. Start `psql`, replacing placeholders with your database connection details:

            ``` sh
            PGPASSWORD=<password> psql \
            --host=<database_endpoint> \ # (1)
            --port=<port> \
            --username=<username> \
            --dbname=<database_name>
            ```

            1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

            You should now be in the SQL shell, where you can query your database.

            !!! warning

                If you can't connect, there are likely errors in the `psql` connection details or in your VPC configuration. Review these details, fix any errors, and try running `psql` again.

                Do not move on to the next step until you successfully connect from your EKS cluster; if you can't do so now, ReadySet won't be able to connect later.

        3. Stop `psql` and delete the temporary pod:

            ``` sql
            \q
            ```        

            ``` sh
            exit
            ```        

    === "RDS MySQL"

        1. In your EKS cluster, create a temporary pod containing the `mysql` client:

            ``` sh
            kubectl run rs-mysql-client \
            --rm --tty -i \
            --restart='Never' \
            --image=docker.io/bitnami/mysql:8.0.30-debian-11-r6 \
            --namespace=default \
            --command -- bash
            ```

        2. Start `mysql`, replacing placeholders with your database connection details:

            ``` sh
            mysql \
            --host=<database_endpoint> \ # (1)
            --port=<port> \
            --user=<username> \
            --password=<password> \
            --database=<database_name>
            ```

            1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

            You should now be in the SQL shell, where you can query your database.

            !!! warning

                If you can't connect, there are likely errors in the `mysql` connection details or in your VPC configuration. Review these details, fix any errors, and try running `mysql` again.

                Do not move on to the next step until you successfully connect from your EKS cluster; if you can't do so now, ReadySet won't be able to connect later.

        3. Stop `mysql` and delete the temporary pod:

            ``` sql
            \q
            ```        

            ``` sh
            exit
            ```        

4. Create a Kubernetes secret with your database connection details. ReadySet will use this secret to connect to the database.

    === "RDS Postgres"

        1. Set environment variables with your database connection details:

            !!! note "Replication scope"

                By default, ReadySet will replicate all tables in all schemas of the database specified in `DB_NAME`. If the queries you want to cache with ReadySet touch only a specific schema or specific tables in a schema, you can restrict the scope of replication accordingly. See [Step 4](#step-4-configure-readyset) for more details.

            ``` sh
            export DB_USERNAME="<username>"
            ```

            ``` sh
            export DB_PASSWORD="<password>"
            ```

            ``` sh
            export DB_NAME="<database_name>"
            ```

            ``` sh
            export RDS_ENDPOINT="<database_endpoint>" # (1)
            ```

            1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

            ```sh
            export CONN_STRING="postgresql://${DB_USERNAME}:${DB_PASSWORD}@${RDS_ENDPOINT}:5432/${DB_NAME}"
            ```

        2. Create the secret:

            ``` sh
            kubectl create secret \
              generic \
              readyset-db-url \
              --from-literal=url="${CONN_STRING}" \
              --from-literal=username="${DB_USERNAME}" \
              --from-literal=database="${DB_NAME}" \
              --from-literal=password="${DB_PASSWORD}"
            ```

            ``` {.text .no-copy}
            secret/readyset-db-url created
            ```

    === "RDS MySQL"

        1. Set environment variables with your database connection details:

            !!! note "Replication scope"

                By default, ReadySet will replicate all tables in the database specified in `DB_NAME`. If the queries you want to cache with ReadySet touch only specific tables in the database, you can restrict the scope of replication accordingly. See [Step 4](#step-4-configure-readyset) for more details.

            ``` sh
            export DB_USERNAME="<username>"
            ```

            ``` sh
            export DB_PASSWORD="<password>"
            ```

            ``` sh
            export DB_NAME="<database_name>"
            ```

            ``` sh
            export RDS_ENDPOINT="<database_endpoint>" # (1)
            ```

            1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

            ```sh
            export CONN_STRING="mysql://${DB_USERNAME}:${DB_PASSWORD}@${RDS_ENDPOINT}:3306/${DB_NAME}"
            ```

        2. Create the secret:

            ``` sh
            kubectl create secret \
              generic \
              readyset-db-url \
              --from-literal=url="${CONN_STRING}" \
              --from-literal=username="${DB_USERNAME}" \
              --from-literal=database="${DB_NAME}" \
              --from-literal=password="${DB_PASSWORD}"
            ```

            ``` {.text .no-copy}
            secret/readyset-db-url created
            ```

## Step 2. Set up load balancing

In this step, you'll install an AWS Network Load Balancer Controller into your Kubernetes cluster. When you deploy ReadySet with the Helm chart, Kubernetes will use this Controller to provision a load balancer for your deployment. The load balancer will be able to handle queries sent to ReadySet from outside of the Kubernetes cluster.

1. Complete the installation steps described in the [AWS Network Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html) documentation.

2. Verify that the network load balancer controller is installed:

    ``` sh
    kubectl get deployment -n kube-system aws-load-balancer-controller
    ```

    ``` {.text .no-copy}
    NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
    aws-load-balancer-controller   2/2     2            2           84s
    ```

## Step 3. Configure your database

In this step, you'll configure your database so that ReadySet can consume the database's replication stream, which ReadySet uses to keep its cache up-to-date as the database changes. In Postgres, the replication stream is called [logical replication](https://www.postgresql.org/docs/current/logical-replication.html). In MySQL, the replication stream is called the [binary log](https://dev.mysql.com/doc/refman/5.7/en/binary-log.html).

=== "RDS Postgres"

    1. In your EKS cluster, create a temporary pod containing the `psql` client:

        ``` sh
        kubectl run rs-postgres-client \
        --rm --tty -i \
        --restart='Never' \
        --image=postgres \
        --namespace=default \
        --command -- bash
        ```

    2. Start `psql`, replacing placeholders with your database connection details:

        ``` sh
        PGPASSWORD=<password> psql \
        --host=<database_endpoint> \ # (1)
        --port=<port> \
        --username=<username> \
        --dbname=<database_name>
        ```

        1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

    3. ReadySet uses Postgres [logical replication](https://www.postgresql.org/docs/current/logical-replication.html) to keep the cache up-to-date as the underlying database changes. In the `psql` shell, check if replication is enabled:

        ``` sql
        SELECT name,setting
          FROM pg_settings
          WHERE name = 'rds.logical_replication';
        ```

        If replication is already on, skip to [Step 4. Start ReadySet](#step-4-start-readyset):

        ``` {.text .no-copy}
                name             | setting
        -------------------------+---------
        rds.logical_replication  | on
        (1 row)
        ```

        If replication is off, continue to the next step:

        ``` {.text .no-copy}
                name             | setting
        -------------------------+---------
        rds.logical_replication  | off
        (1 row)
        ```

    4. [Create a custom parameter group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Creating).

        - For **Parameter group family**, select the Postgres version of your database.
        - For **Type**, select **DB Parameter Group**.
        - Give the group a name and description.

    5. Edit the new parameter group and set the `rds.logical_replication` parameter to `1`.

    6. [Associate the parameter group to your database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Associating).

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the parameter group association to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    7. Back in the SQL shell, verify that replication is now enabled:

        ``` sql
        SELECT name,setting
          FROM pg_settings
          WHERE name = 'rds.logical_replication';
        ```

        ``` {.text .no-copy}
                name             | setting
        -------------------------+---------
        rds.logical_replication  | on
        (1 row)
        ```

        !!! note

            If replication is still not enabled, [reboot the database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RebootInstance.html).

            Once the database **Status** is **Available** in the RDS Console, check replication again.

    8. Stop `psql` and delete the temporary pod:

        ``` sql
        \q
        ```        

        ``` sh
        exit
        ```        

=== "RDS MySQL"

    1. In RDS MySQL, the [binary log](https://dev.mysql.com/doc/refman/5.7/en/binary-log.html) is enabled only when automated backups are also enabled. If you didn't enable automated backups when creating your database instance, [enable automated backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html#USER_WorkingWithAutomatedBackups.Enabling) now.

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the change to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    2. In your EKS cluster, create a temporary pod containing the `mysql` client:

        ``` sh
        kubectl run rs-mysql-client \
        --rm --tty -i \
        --restart='Never' \
        --image=docker.io/bitnami/mysql:8.0.30-debian-11-r6 \
        --namespace=default \
        --command -- bash
        ```

    3. Start `mysql`, replacing placeholders with your database connection details:

        ``` sh
        mysql \
        --host=<database_endpoint> \ # (1)
        --port=<port> \
        --user=<username> \
        --password=<password> \
        --database=<database_name>
        ```

        1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.


    2. In the `mysql` shell, verify that replication is enabled:


        ``` sql
        SHOW VARIABLES LIKE 'log_bin';
        ```

        ``` {.text .no-copy}
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | log_bin       | ON    |
        +---------------+-------+
        1 row in set (0.00 sec)
        ```

        !!! note

            If replication is still not enabled, [reboot the database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RebootInstance.html).

            Once the database **Status** is **Available** in the RDS Console, check replication again.

    3. Check the [binary logging format](https://dev.mysql.com/doc/refman/5.7/en/binary-log-setting.html):

        ``` sql
        SHOW VARIABLES LIKE 'binlog_format';
        ```

        If the binary logging format is `ROW`, skip to [Step 4. Start ReadySet](#step-4-start-readyset):

        ``` {.text .no-copy}
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | binlog_format | ROW   |
        +---------------+-------+
        1 row in set (0.00 sec)
        ```

        If the binary logging format is **not** `ROW`, continue to the next step:

        ``` {.text .no-copy}
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | binlog_format | MIXED |
        +---------------+-------+
        1 row in set (0.00 sec)
        ```

    4. [Create a custom parameter group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Creating).

        - For **Parameter group family**, select the MySQL version of your database.
        - For **Type**, select **DB Parameter Group**.
        - Give the group a name and description.

    5. Edit the new parameter group and set the `binlog_format` parameter to `ROW`.

    6. [Associate the parameter group to your database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Associating).

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the parameter group association to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    7. Back in the SQL shell, verify that the binary logging format is `ROW`:

        ``` sql
        SHOW VARIABLES LIKE 'binlog_format';
        ```

        ``` {.text .no-copy}
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | binlog_format | ROW   |
        +---------------+-------+
        1 row in set (0.00 sec)
        ```

        !!! note

            If the binary logging format is still not `ROW`, [reboot the database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RebootInstance.html).

            Once the database **Status** is **Available** in the RDS Console, check the binary logging format again.

    8. Stop `msql` and delete the temporary pod:

        ``` sql
        \q
        ```        

        ``` sh
        exit
        ```

## Step 4. Configure ReadySet

In this step, you'll download and edit the configuration files for deploying ReadySet.

2. Clone the [`readyset` GitHub repository](https://github.com/readysettech/readyset):

    ``` sh
    git clone git@github.com:readysettech/readyset.git
    ```

3. Move into to the `readysettech/readyset/helm/readyset` directory. This directory contains the `Chart.yaml` and `values.yaml` files that Helm needs to deploy ReadySet.

4. By default, Helm uses the `latest` docker image tag for the ReadySet Server and Adapter. This tag is updated nightly and so represents different versions of ReadySet over time. To ensure that you deploy a fixed version of ReadySet, it's important to use the tag for a specific version.

    1. Get the available image tags for the ReadySet Server and Adapter:

        ``` sh
        TOKEN=$(curl -k https://public.ecr.aws/token/ | jq -r '.token')
        ```

        ``` sh
        curl -k -H "Authorization: Bearer $TOKEN" \
        https://public.ecr.aws/v2/readyset/readyset-server/tags/list
        ```

        ``` sh
        curl -k -H "Authorization: Bearer $TOKEN" \
        https://public.ecr.aws/v2/readyset/readyset-adapter/tags/list
        ```

        The results will look like this:

        ``` {.text .no-copy}
        {"name":"readyset/readyset-server","tags":["d3f36b07c8edd41c9ec558654b0cd6b1998eee61","latest"]}
        {"name":"readyset/readyset-adapter","tags":["d3f36b07c8edd41c9ec558654b0cd6b1998eee61","latest"]}
        ```

    2. In `values.yaml`, change the image tags for the ReadySet Server and Adapter from `latest` to a specific version:

        ``` sh hl_lines="9"
        # -- Container image settings for ReadySet server.
        # @default -- Truncated due to length.
        image:

          # -- Image repository to use for ReadySet server.
          repository: public.ecr.aws/readyset/readyset-server

          # -- Image tag to use for ReadySet server.
          tag: "latest"
        ```

        ``` sh hl_lines="9"
        # -- Container image settings for ReadySet adapter.
        # @default -- Truncated due to length.
        image:

          # -- Image repository to use for ReadySet adapter.
          repository: public.ecr.aws/readyset/readyset-adapter

          # -- Image tag to use for ReadySet adapter.
          tag: "latest"
        ```

        !!! warning

            The ReadySet Server and Adapter must run the same version of ReadySet, so be sure to use matching image tags for the Server and Adapter.

5. In `values.yaml`, configure your deployment to use the ReadySet Adapter for your database:

    === "RDS Postgres"

        ```  sh hl_lines="3"
        # -- Flag to instruct entrypoint script which adapter binary to use.
        # Supported values: mysql, psql
        engine: "psql"
        ```

    === "RDS MySQL"

        ```  sh hl_lines="3"
        # -- Flag to instruct entrypoint script which adapter binary to use.
        # Supported values: mysql, psql
        engine: "mysql"
        ```

6. In `values.yaml`, change the storage size to be 2x the size of your database:

    ``` sh hl_lines="10"
    volumeClaimTemplates:
    - metadata:
        name: state
      spec:
        storageClassName: gp2
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 250Gi
    ```

    !!! note

        The `values.yaml` file contains the CPU, memory, and storage specifications for the components of your deployment. The default values are suitable for testing purposes only. For production deployments, you'll need to substitute values that are appropriate for your database and workload. Please [reach out](mailto:info@readyset.io) to ReadySet for guidance.

7. In `values.yaml`, set environment variables to disable verification of SSL certifications on the ReadySet Server and ReadySet adapter. This is necessary because ReadySet cannot currently verify Amazon's self-signed certificates.

    ``` sh hl_lines="4"
    # -- Static environment variables to be applied to ReadySet server containers.
    extraEnvironmentVars:

      DISABLE_UPSTREAM_SSL_VERIFICATION: "1"
    ```

    ``` sh hl_lines="4-5"
    # -- Static environment variables applied to ReadySet adapter containers.
    extraEnvironmentVars:

      DISABLE_UPSTREAM_SSL_VERIFICATION: "1"
    ```

8. By default, ReadySet will replicate all data in the database specified in the ReadySet secret that you created earlier. If the queries you want to cache with ReadySet touch only specific tables in the database, you can set the `REPLICATION_TABLES` environment variable to restrict the replication scope accordingly:

    === "RDS Postgres"

        ``` sh hl_lines="4"
        # -- Static environment variables to be applied to ReadySet server containers.
        extraEnvironmentVars:

          REPLICATION_TABLES: "<schmema>.<table>,<schmema>.<table>"
        ```

        To replicate all tables in a schema, use `<schema>.*`.

    === "RDS MySQL"

        ``` sh hl_lines="4"
        # -- Static environment variables to be applied to ReadySet server containers.
        extraEnvironmentVars:

          REPLICATION_TABLES: "<database>.<table>,<database>.<table>"
        ```

## Step 5. Start ReadySet

In this step, you'll use the Helm package manager to deploy ReadySet into your EKS cluster.

1. [Install the Helm client](https://helm.sh/docs/intro/install/).

2. Use the ReadySet Helm chart to deploy ReadySet to your EKS cluster:

    ``` sh
    helm install readyset . --values values.yaml
    ```    

3. Confirm that the ReadySet deployment completed successfully, with the pods for the ReadySet Adapter, ReadySet Server, and Consul showing `Running` under `STATUS`:

    ``` sh
    kubectl get pods -o wide
    ```

    ``` {.text .no-copy}
    NAME                                        READY   STATUS    RESTARTS   AGE   IP               NODE                             NOMINATED NODE   READINESS GATES
    readyset-consul-server-0                    1/1     Running   0          5m    192.168.39.169   ip-192-168-43-246.ec2.internal   <none>           <none>
    readyset-readyset-adapter-9dbfb77d9-ml92h   2/2     Running   0          5m    192.168.48.46    ip-192-168-43-246.ec2.internal   <none>           <none>
    readyset-readyset-server-0                  2/2     Running   0          5m    192.168.18.133   ip-192-168-18-84.ec2.internal    <none>           <none>
    ```

4. Confirm that the persistent volumes for storing ReadySet's snapshot of your database and for ReadySet state details were created successfully:

    ``` sh
    kubectl get pv
    ```

    ``` {.text .no-copy}
    NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                           STORAGECLASS   REASON   AGE
    pvc-d792b6a8-35ae-456d-8c92-415e473931dc   10Gi       RWO            Delete           Bound    default/data-default-readyset-consul-server-0   gp2                     5m
    pvc-ddf75696-9eb7-4e28-a846-2110e889c8de   250Gi      RWO            Delete           Bound    default/state-readyset-readyset-server-0        gp2                     5m
    ```

5. Depending on the size of your dataset, it can take ReadySet between a few minutes to several hours to create an initial snapshot. Until the entire snapshot is finished, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked. In MySQL, `INSERT` and `UPDATE` statements will also be blocked, but only while a given table is being snapshotted.

    Check on the snapshotting process:

    === "RDS Postgres"

        ``` sh
        export SERVER=$(kubectl get pods | grep readyset-server | cut -d' ' -f1);
        ```

        ``` sh
        kubectl logs ${SERVER} -c readyset-server | grep 'snapshot'
        ```

        ```
        2022-09-27T18:13:10.809288Z  INFO Replicating table: replicators::postgres_connector::snapshot: Snapshotting started rows=4990 table=`public`.`users`
        2022-09-27T18:13:10.818057Z  INFO Replicating table: replicators::postgres_connector::snapshot: Snapshotting finished rows_replicated=4990 table=`public`.`users`
        2022-09-27T18:13:10.846017Z  INFO Replicating table: replicators::postgres_connector::snapshot: Snapshotting started rows=5000 table=`public`.`posts`
        2022-09-27T18:13:10.855421Z  INFO Replicating table: replicators::postgres_connector::snapshot: Snapshotting finished rows_replicated=5000 table=`public`.`posts`
        2022-09-27T18:13:10.971007Z  INFO replicators::noria_adapter: Snapshot finished
        ```

        !!! note

            Do not move on to the next step until you see the `Snapshot finished` message.

    === "RDS MySQL"

        ``` sh
        export SERVER=$(kubectl get pods | grep readyset-server | cut -d' ' -f1);
        ```

        ``` sh
        kubectl logs ${SERVER} -c readyset-server | grep 'taking database snapshot'
        ```

        ```
        2022-10-18T17:18:01.685613Z  INFO taking database snapshot: replicators::noria_adapter: Starting snapshot
        2022-10-18T17:18:01.803163Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Acquiring read lock table=`readyset`.`users`
        2022-10-18T17:18:01.807475Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replicating table table=`readyset`.`users`
        2022-10-18T17:18:01.809739Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Read lock released table=`readyset`.`users`
        2022-10-18T17:18:01.810049Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Acquiring read lock table=`readyset`.`posts`
        2022-10-18T17:18:01.816496Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replicating table table=`readyset`.`posts`
        2022-10-18T17:18:01.818721Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Read lock released table=`readyset`.`posts`
        2022-10-18T17:18:01.822144Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication started rows=4990 table=`readyset`.`users`
        2022-10-18T17:18:01.822376Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication started rows=5000 table=`readyset`.`posts`
        2022-10-18T17:18:01.863220Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication finished rows_replicated=4990 table=`readyset`.`users`
        2022-10-18T17:18:01.864316Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication finished rows_replicated=5000 table=`readyset`.`posts`
        2022-10-18T17:18:01.966256Z  INFO taking database snapshot: replicators::noria_adapter: Snapshot finished
        ```

        !!! note

            Do not move on to the next step until you see the `Snapshot finished` message.

6. Confirm that ReadySet is receiving the database's replication stream:

    === "RDS Postgres"

        ``` sh
        kubectl logs ${SERVER} -c readyset-server | grep 'Streaming'
        ```

        ```
        2022-09-27T18:13:10.971931Z  INFO replicators::noria_adapter: Streaming replication started
        ```

    === "RDS MySQL"

        ``` sh
        kubectl logs ${SERVER} -c readyset-server | grep 'MySQL connected'
        ```

        ```
        2022-09-30T16:14:13.371646Z  INFO replicators::noria_adapter: MySQL connected
        ```

    !!! tip

        To follow the full ReadySet Server logs, use:

        ``` sh
        export SERVER=$(kubectl get pods | grep readyset-server | cut -d' ' -f1);
        ```

        ``` sh
        kubectl logs ${SERVER} -c readyset-server -f
        ```

        To follow the ReadySet Adapter logs, use:

        ``` sh
        export ADAPTER=$(kubectl get pods | grep readyset-adapter | cut -d' ' -f1);
        ```

        ``` sh
        kubectl logs ${ADAPTER} -c readyset-adapter -f
        ```        

7. Confirm that a load balancer service was created successfully:

    ``` sh
    kubectl get service/readyset-readyset-adapter
    ```

    ```
    NAME                        TYPE           CLUSTER-IP      EXTERNAL-IP                                                                    PORT(S)                         AGE
    readyset-readyset-adapter   LoadBalancer   10.100.46.222   k8s-default-readyset-3cab417124-2b191c9917ce4d43.elb.us-east-1.amazonaws.com   3306:30336/TCP,5432:30185/TCP   5m
    ```
    Do not move on to the next step until an `EXTERNAL-IP` has been assigned to the load balancer. This may take a few minutes.

8. Check that you can connect to ReadySet via the load balancer.

    === "RDS Postgres"

        1. In your EKS cluster, create a temporary pod containing the `psql` client:

            ``` sh
            kubectl run rs-postgres-client \
            --rm --tty -i \
            --restart='Never' \
            --image=postgres \
            --namespace=default \
            --command -- bash
            ```

        2. Start `psql`, replacing the `--host` placeholder with the external IP of your load balancer, and replacing the other placeholders with your database connection details:

            ``` sh
            PGPASSWORD=<password> psql \
            --host=<external IP of load balancer> \
            --port=<port> \
            --username=<username> \
            --dbname=<database_name>
            ```

            You should now be in the SQL shell, where you can query your database.

    === "RDS MySQL"

        1. In your EKS cluster, create a temporary pod containing the `mysql` client:

            ``` sh
            kubectl run rs-mysql-client \
            --rm --tty -i \
            --restart='Never' \
            --image=docker.io/bitnami/mysql:8.0.30-debian-11-r6 \
            --namespace=default \
            --command -- bash
            ```

        2. Start `mysql`, replacing the `--host` placeholder with the external IP of your load balancer, and replacing the other placeholders with your database connection details:

            ``` sh
            mysql \
            --host=<external IP of load balancer> \
            --port=<port> \
            --user=<username> \
            --password=<password> \
            --database=<database_name>
            ```

            You should now be in the SQL shell, where you can query your database.

## Next steps

- Set up monitoring

    The ReadySet Server and ReadySet Adapter export granular time series metrics at `<adapter IP or host>:6033/prometheus>` and `<server IP or host>:6034/prometheus`, respectively. The metrics are formatted for easy integration with [Prometheus](https://prometheus.io/), an open source tool you can use to for storing, aggregating, and querying time series data. You can use this data to, for example, profile SQL query latencies and identify queries to cache with ReadySet.

    ??? tip "Viewing Prometheus metrics"

        To view the Prometheus metrics exported by the ReadySet Adapter:

        1. Get the IP of the ReadySet Adapter pod:

            ``` sh
            export ADAPTER=$(kubectl get pods | grep readyset-adapter | cut -d' ' -f1);
            ```

            ``` sh
            kubectl get pods \
            --field-selector=metadata.name=${ADAPTER} \
            -o=jsonpath='{range.items[*]}{.metadata.item} {.status.podIP} {"\n"}{end}'
            ```

        2. Create a temporary pod containing the `curl` command:

            ``` sh
            kubectl run mycurlpod \
            --rm --tty -i \
            --restart='Never' \
            --image=curlimages/curl -- sh
            ```

        3. Make the `GET` requests to the Prometheus endpoint:

            ``` sh
            curl -X GET <IP of ReadySet Adapter pod>:6033/prometheus
            ```

        To view the Prometheus metrics exported by the ReadySet Server:

        1. Get the IP of the ReadySet Server pod:

            ``` sh
            export SERVER=$(kubectl get pods | grep readyset-server | cut -d' ' -f1);
            ```

            ``` sh
            kubectl get pods \
            --field-selector=metadata.name=${SERVER} \
            -o=jsonpath='{range.items[*]}{.metadata.item} {.status.podIP} {"\n"}{end}'
            ```

        2. Create a temporary pod containing the `curl` command:

            ``` sh
            kubectl run mycurlpod \
            --rm --tty -i \
            --restart='Never' \
            --image=curlimages/curl -- sh
            ```

        3. Make the `GET` requests to the Prometheus endpoint:

            ``` sh
            curl -X GET <IP of ReadySet Server pod>:6033/prometheus
            ```

- Cache queries

    Once you've identified queries to cache, use ReadySet's [custom SQL commands](cache-queries.md) to do so.
