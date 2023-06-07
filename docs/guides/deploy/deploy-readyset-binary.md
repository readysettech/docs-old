# Deploy ReadySet with Binary

This page shows you how to manually deploy ReadySet on Amazon EC2 in front of a Supabase, Amazon RDS Postgres, or Amazon RDS MySQL database.

## Before you begin

=== "Supabase Postgres"

    - Note that this tutorial deploys the ReadySet Server and ReadySet Adapter running as a single process on a single machine.

    - Make sure you have a [Supabase](https://supabase.com/) database running Postgres 13 or 14.

        If you want to integrate with another version of Postgres, please [contact ReadySet](mailto:info@readyset.io).

    - Make sure there are no DDL statements in progress.

        ReadySet will take an initial snapshot of your data. Until the entire snapshot is finished, which can take between a few minutes to several hours depending on the size of your dataset, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked.

    - Make sure [row-level security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) is disabled.

        ReadySet does not currently support row-level security.

=== "RDS Postgres"

    - Note that this tutorial deploys the ReadySet Server and ReadySet Adapter running as a single process on a single machine.

    - Make sure you have an [Amazon RDS for Postgres](https://aws.amazon.com/rds/postgresql/) database running Postgres 13 or 14.

        If you want to integrate with another version of Postgres, please [contact ReadySet](mailto:info@readyset.io).

    - Make sure there are no DDL statements in progress.

        ReadySet will take an initial snapshot of your data. Until the entire snapshot is finished, which can take between a few minutes to several hours depending on the size of your dataset, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked.

    - Make sure [row-level security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) is disabled.

        ReadySet does not currently support row-level security.

=== "RDS MySQL"

    - Note that this tutorial deploys the ReadySet Server and ReadySet Adapter running as a single process on a single machine.

    - Make sure you have an [Amazon RDS for MySQL](https://aws.amazon.com/rds/mysql/) database running MySQL 8.

        If you want to integrate with another version of MySQL, please [contact ReadySet](mailto:info@readyset.io).

    - Make sure there are no DDL statements in progress.

        ReadySet will take an initial snapshot of your data. Until the entire snapshot is finished, which can take between a few minutes to several hours depending on the size of your dataset, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked, and `INSERT` and `UPDATE` statements will also be blocked, but only while a given table is being snapshotted.

## Step 1. Configure your database

In this step, you'll configure your database so that ReadySet can consume the database's replication stream, which ReadySet uses to keep its cache up-to-date as the database changes.

=== "Supabase Postgres"

    In Supabase, [replication](https://www.postgresql.org/docs/current/logical-replication.html) is already enabled. However, you must change the `postgres` user's permissions so that ReadySet can create a replication slot.  

    1. In the Supabase Dashboard, go to the **SQL Editor**.

    1. Change the `postgres` user's permissions to `SUPERUSER`:

        ``` sql
        ALTER USER postgres WITH SUPERUSER;
        ```

=== "RDS Postgres"

    1. Connect the [`psql` shell](https://www.postgresql.org/docs/current/app-psql.html) to your database, replacing placeholders with your database connection details:

        ``` sh
        PGPASSWORD=<db_password> psql \
        --host=<db_endpoint> \
        --port=5432 \
        --username=<db_username> \
        --dbname=<db_name>
        ```

        !!! tip

            To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

    1. Check if [replication](https://www.postgresql.org/docs/current/logical-replication.html) is enabled:

        ``` sql
        SELECT name,setting
          FROM pg_settings
          WHERE name = 'rds.logical_replication';
        ```

        If replication is already on, skip to [Step 2](#step-2-start-readyset):

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

    1. [Create a custom parameter group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Creating).

        - For **Parameter group family**, select the Postgres version of your database.
        - For **Type**, select **DB Parameter Group**.
        - Give the group a name and description.

    1. Edit the new parameter group and set the `rds.logical_replication` parameter to `1`.

    1. [Associate the parameter group to your database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Associating).

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the parameter group association to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    1. Back in the `psql` shell, verify that replication is now enabled:

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

        !!! tip

            If replication is still not enabled, [reboot the database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RebootInstance.html).

            Once the database **Status** is **Available** in the RDS Console, check replication again.

=== "RDS MySQL"

    1. In RDS MySQL, [replication](https://dev.mysql.com/doc/refman/5.7/en/replication.html) is enabled only when automated backups are also enabled. If you didn't enable automated backups when creating your database instance, [enable automated backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html#USER_WorkingWithAutomatedBackups.Enabling) now.

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the change to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    1. Connect the [`mysql` shell](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) to your database, replacing placeholders with your database connection details:

        ``` sh
        mysql \
        --host=<db_endpoint> \
        --port=3306 \
        --user=<db_username> \
        --password=<db_password> \
        --database=<db_name>
        ```

        !!! tip

            To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

    1. In the `mysql` shell, verify that replication is enabled:

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

        !!! tip

            If replication is still not enabled, [reboot the database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RebootInstance.html).

            Once the database **Status** is **Available** in the RDS Console, check replication again.

    1. Check the [binary logging format](https://dev.mysql.com/doc/refman/5.7/en/binary-log-setting.html):

        ``` sql
        SHOW VARIABLES LIKE 'binlog_format';
        ```

        If the binary logging format is `ROW`, skip to [Step 2](#step-2-start-readyset):

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

    1. [Create a custom parameter group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Creating).

        - For **Parameter group family**, select the MySQL version of your database.
        - For **Type**, select **DB Parameter Group**.
        - Give the group a name and description.

    1. Edit the new parameter group and set the `binlog_format` parameter to `ROW`.

    1. [Associate the parameter group to your database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Associating).

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the parameter group association to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    1. Back in the SQL shell, verify that the binary logging format is `ROW`:

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

        !!! tip

            If the binary logging format is still not `ROW`, [reboot the database](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RebootInstance.html).

            Once the database **Status** is **Available** in the RDS Console, check the binary logging format again.

## Step 2. Create an EC2 instance

In this step, you'll provision and configure an EC2 instance for ReadySet.

1. [Launch an EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) for ReadySet:

    - **Region:** ReadySet consumes your database's replication stream, so launch the instance in the same region as your database for optimal performance.
    - **OS image:** Choose **Amazon Linux 2** with a **64-bit (x86)** architecture.
    - **Instance type:** ReadySet is a memory-intensive application, so choose an instance type that can comfortable hold your working data in memory. We recommend starting with `m6a.xlarge` (4 vCPUs, 16 GiB of RAM), `m6a.2xlarge` (8 vCPUs, 32 GiB of RAM), or `m6a.4xlarge` (16 vCPUs, 64 GiB of RAM).
    - **Networking:** Accept the defaults to create a new security group and allow SSH traffic from anywhere. You'll adjust networking in the next step.
    - **Key pair:** Add a key pair so you have SSH access to the instance. This is necessary for distributing and starting the ReadySet binary.
    - **Storage:** As the basis for caching and maintaining query results in-memory, ReadySet stores and maintains a snapshot of your database on disk. To accommodate growth in your dataset, size storage to 2x the size of your database.

1. Configure networking for ReadySet:

    === "Supabase Postgres"

        - To allow you to connect the `psql` shell to ReadySet, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your your EC2 instance's security group with the following details:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `5432` | `0.0.0.0/0` or your local IP

        - To allow your application to connect to ReadySet, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your your EC2 instance's security group with the following details:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `5432` | IP range of your application

    === "RDS Postgres"

        - To allow ReadySet to connect to your upstream database, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your database's security group:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `5432` | IP range of ReadySet's EC2 instance

        - To allow you to connect the `psql` shell to ReadySet, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your your EC2 instance's security group with the following details:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `5432` | `0.0.0.0/0` or your local IP

        - To allow your application to connect to ReadySet, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your your EC2 instance's security group with the following details:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `5432` | IP range of your application

    === "RDS MySQL"

        - To allow ReadySet to connect to your upstream database, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your database's security group:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `6033` | IP range of ReadySet's EC2 instance

        - To allow you to connect the `mysql` shell to ReadySet, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your your EC2 instance's security group with the following details:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `6033` | `0.0.0.0/0` or your local IP

        - To allow your application to connect to ReadySet, [add an inbound rule](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html#adding-security-group-rule) to your your EC2 instance's security group with the following details:

            Type | Protocol | Port range | Source
            -----|----------|------------|-------
            Custom TCP | TCP | `6033` | IP range of your application

## Step 3. Start ReadySet

1. SSH to the EC2 instance for ReadySet.

1. Download the latest [Readyset release](../../releases/readyset-core.md) for Linux and extract the binary:

      ``` shell
      curl -sL https://github.com/readysettech/readyset/releases/download/beta-2023-01-18/readyset-beta-2023-01-18.x86_64.tar.gz \
        | tar -xvz  
      ```

1. Copy the binary into the `PATH`:

      ``` shell
      sudo cp -i readyset /usr/local/bin/
      ```

1. Install the database provider's certificate authority so ReadySet can encrypt its connection to the database:

    === "Supabase Postgres"

        ``` shell
        curl -sL https://supabase-downloads.s3-ap-southeast-1.amazonaws.com/prod/ssl/prod-ca-2021.crt \
          | sudo tee  /etc/pki/ca-trust/source/anchors/supabase-prod-ca-2021.crt
        ```

        ``` shell
        sudo update-ca-trust
        ```

    === "RDS Postgres"

        ``` shell
        curl -sL https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem \
          | sudo tee  /etc/pki/ca-trust/source/anchors/aws-global-bundle.pem
        ```

        ``` shell
        sudo update-ca-trust
        ```

    === "RDS MySQL"

        ``` shell
        curl -sL https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem \
          | sudo tee  /etc/pki/ca-trust/source/anchors/aws-global-bundle.pem
        ```

        ``` shell
        sudo update-ca-trust
        ```

1. Create directories for storing ReadySet's snapshot of your database and ReadySet's logs:

    ``` shell
    mkdir db logs
    ```

1. Set environment variables with details you'll need to start ReadySet in the next step.

    === "Supabase Postgres"

        1. Set a unique name for your ReadySet deployment:

            ``` sh
            export RS_DEPLOYMENT="<readyset_deployment_name>"
            ```

        1. Set connection details for your Supabase Postgres database:

            ``` sh
            export DB_PASSWORD="<database_password>"
            ```

            ``` sh
            export DB_HOST="<database_host>"
            ```

            !!! tip

                To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

        1. Set the username and password for ReadySet:

            ``` sh
            export RS_USERNAME="<readyset_username>"
            ```

            ``` sh
            export RS_PASSWORD="<readyset_password>"
            ```

            When connecting your application to ReadySet instead of to the database, you'll use these credentials.

    === "RDS Postgres"

        1. Set a unique name for your ReadySet deployment:

            ``` sh
            export RS_DEPLOYMENT="<readyset_deployment_name>"
            ```

        1. Set connection details for your RDS Postgres database:

            ``` sh
            export DB_USERNAME="<database_username>"
            ```

            ``` sh
            export DB_PASSWORD="<database_password>"
            ```

            ``` sh
            export DB_NAME="<database_name>"
            ```

            ``` sh
            export DB_HOST="<database_endpoint>"
            ```

            !!! tip

                To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

        1. Set the username and password for ReadySet:

            ``` sh
            export RS_USERNAME="<readyset_username>"
            ```

            ``` sh
            export RS_PASSWORD="<readyset_password>"
            ```

            When connecting your application to ReadySet instead of to the database, you'll use these credentials.

    === "RDS MySQL"

        1. Set a unique name for your ReadySet deployment:

            ``` sh
            export RS_DEPLOYMENT="<readyset_deployment_name>"
            ```

        1. Set connection details for your RDS MySQL database:

            ``` sh
            export DB_USERNAME="<database_username>"
            ```

            ``` sh
            export DB_PASSWORD="<database_password>"
            ```

            ``` sh
            export DB_NAME="<database_name>"
            ```

            ``` sh
            export DB_HOST="<database_endpoint>"
            ```

            !!! tip

                To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

        1. Set the username and password for ReadySet:

            ``` sh
            export RS_USERNAME="<readyset_username>"
            ```

            ``` sh
            export RS_PASSWORD="<readyset_password>"
            ```

            When connecting to ReadySet instead of to the database, you'll use these credentials.


1. Run the [`readyset`](../../reference/cli/readyset.md) command to start ReadySet:

    === "Supabase Postgres"

        ``` sh
        readyset \
        --standalone \
        --deployment=${RS_DEPLOYMENT} \
        --upstream-db-url=postgresql://postgres:${DB_PASSWORD}@${DB_HOST}:5432/postgres \
        --database-type=postgresql \
        --query-caching=explicit \
        --username=${RS_USERNAME} \
        --password=${RS_PASSWORD} \
        --address=0.0.0.0:5432 \
        --db-dir=db \
        --prometheus-metrics \
        --metrics-address=0.0.0.0:6034 \
        --query-log \
        --query-log-ad-hoc \
        >> logs/readyset.log 2>&1 &
        ```

        !!! tip

            For details about the `readyset` command options, see the [CLI reference docs](../../reference/cli/readyset.md).

    === "RDS Postgres"

        ``` sh
        readyset \
        --standalone \
        --deployment=${RS_DEPLOYMENT} \
        --upstream-db-url=postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME} \
        --database-type=postgresql \
        --query-caching=explicit \
        --username=${RS_USERNAME} \
        --password=${RS_PASSWORD} \
        --address=0.0.0.0:5432 \
        --db-dir=db \
        --prometheus-metrics \
        --metrics-address=0.0.0.0:6034 \
        --query-log \
        --query-log-ad-hoc \
        >> logs/readyset.log 2>&1 &
        ```

        !!! tip

            For details about the `readyset` command options, see the [CLI reference docs](../../reference/cli/readyset.md).

    === "RDS MySQL"

        ``` sh
        readyset \
        --standalone \
        --deployment=${RS_DEPLOYMENT} \
        --upstream-db-url=mysql://${DB_USERNAME}:${DB_PASSWORD}@${DB_ENDPOINT}:6033/${DB_NAME} \
        --database-type=mysql \
        --query-caching=explicit \
        --username=${RS_USERNAME} \
        --password=${RS_PASSWORD} \
        --address=0.0.0.0:6033 \
        --db-dir=db \
        --prometheus-metrics \
        --metrics-address=0.0.0.0:6034 \
        --query-log \
        --query-log-ad-hoc \
        >> logs/readyset.log 2>&1 &
        ```

        !!! tip

            For details about the `readyset` command options, see the [CLI reference docs](../../reference/cli/readyset.md).

## Step 4. Check snapshotting

As soon as ReadySet is connected to the database, it starts storing a snapshot of your database tables on disk. This snapshot will be the basis for ReadySet to cache query results, and ReadySet will keep its snapshot and cache up-to-date automatically by listening to the database's replication stream. Queries can be cached in ReadySet only once all tables have finished the initial snapshotting process.

In this step, you'll check the status of the snapshotting process. Snapshotting can take between a few minutes to several hours, depending on the size of your dataset.

=== "Postgres Supabase"

    1. Connect the [`psql` shell](https://www.postgresql.org/docs/current/app-psql.html) to ReadySet, replacing placeholders with your ReadySet connection details:

        ``` sh
        PGPASSWORD=<readyset_password> psql \
        --host=<readyset_address> \
        --port=5432 \
        --username=<readyset_username> \
        --dbname=<db_name>
        ```

        !!! tip

            To find the public address of the EC2 instance where ReadySet is running, select your instance in the EC2 Console, and look for **Public IPv4 DNS**.

        You should now be in the SQL shell.

    1. Use ReadySet's custom [`SHOW READYSET TABLES`](../cache/check-snapshotting.md#check-overall-status) command to check the snapshotting status of tables in the database ReadySet is connected to:

        ``` sql
        SHOW READYSET TABLES;
        ```

        ``` {.text .no-copy}
                 table            |    status
        ------------------------------------------
        `public`.`title_basics`   | Snapshotting
        `public`.`title_ratings`  | Snapshotted
        `public`.`title_episodes` | Not Replicated
        (3 rows)
        ```

        There are 3 possible statuses:

        - **Snapshotting:** The initial snapshot of the table is in progress.
        - **Snapshotted:** The initial snapshot of the table is complete. ReadySet is replicating changes to the table via the database's replication stream.
        - **Not Replicated:** The table has not been snapshotted by ReadySet. This can be because ReadySet encountered an error (e.g., due to [unsupported data types](../../reference/sql-support.md#data-types)) or the table has been intentionally excluded from snapshotting (via the [`--replication-tables`](../../reference/cli/readyset.md#-replication-tables) option).

        !!! info

            You can start [caching queries]((../cache/cache-queries.md#cache-queries_1) in ReadySet only once all tables with the `Snapshotting` status have finished snapshotting and show the `Snapshotted` status.

    1. If you'd like to track snapshotting progress in greater detail, exit the SQL shell, SSH to the machine where ReadySet is running, and then check the ReadySet logs:

        ``` sh
        grep 'Snapshotting table' logs/readyset.log
        ```

        !!! note

            For each table, you'll see the progress and the estimated time remaining in the log messages (e.g., `progress=84.13% estimate=00:00:23`).

        ``` {.text .no-copy}
        2022-12-13T16:02:48.142605Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "readyset-test"})
        2022-12-13T16:02:48.202895Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "readyset-test"})
        2022-12-13T16:02:48.357445Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "readyset-test"}) rows=1246402
        2022-12-13T16:02:48.921839Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "readyset-test"}) rows=5159701
        2022-12-13T16:03:11.155418Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "readyset-test"}) rows_replicated=1246402
        2022-12-13T16:03:19.927790Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "readyset-test"}) rows_replicated=1126400 progress=21.83% estimate=00:01:51
        ...
        ```

=== "RDS Postgres"

    1. Connect the [`psql` shell](https://www.postgresql.org/docs/current/app-psql.html) to ReadySet, replacing placeholders with your ReadySet connection details:

        ``` sh
        PGPASSWORD=<readyset_password> psql \
        --host=<readyset_address> \
        --port=5432 \
        --username=<readyset_username> \
        --dbname=<db_name>
        ```

        !!! tip

            To find the public address of the EC2 instance where ReadySet is running, select your instance in the EC2 Console, and look for **Public IPv4 DNS**.

        You should now be in the SQL shell.

    1. Use ReadySet's custom [`SHOW READYSET TABLES`](../cache/check-snapshotting.md#check-overall-status) command to check the snapshotting status of tables in the database ReadySet is connected to:

        ``` sql
        SHOW READYSET TABLES;
        ```

        ``` {.text .no-copy}
                 table            |    status
        ------------------------------------------
        `public`.`title_basics`   | Snapshotting
        `public`.`title_ratings`  | Snapshotted
        `public`.`title_episodes` | Not Replicated
        (3 rows)
        ```

        There are 3 possible statuses:

        - **Snapshotting:** The initial snapshot of the table is in progress.
        - **Snapshotted:** The initial snapshot of the table is complete. ReadySet is replicating changes to the table via the database's replication stream.
        - **Not Replicated:** The table has not been snapshotted by ReadySet. This can be because ReadySet encountered an error (e.g., due to [unsupported data types](../../reference/sql-support.md#data-types)) or the table has been intentionally excluded from snapshotting (via the [`--replication-tables`](../../reference/cli/readyset.md#-replication-tables) option).

        !!! info

            You can start [caching queries]((../cache/cache-queries.md#cache-queries_1) in ReadySet only once all tables with the `Snapshotting` status have finished snapshotting and show the `Snapshotted` status.

    1. If you'd like to track snapshotting progress in greater detail, exit the SQL shell, SSH to the machine where ReadySet is running, and then check the ReadySet logs:

        ``` sh
        grep 'Snapshotting table' logs/readyset.log
        ```

        !!! note

            For each table, you'll see the progress and the estimated time remaining in the log messages (e.g., `progress=84.13% estimate=00:00:23`).

        ``` {.text .no-copy}
        2022-12-13T16:02:48.142605Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "readyset-test"})
        2022-12-13T16:02:48.202895Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "readyset-test"})
        2022-12-13T16:02:48.357445Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "readyset-test"}) rows=1246402
        2022-12-13T16:02:48.921839Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "readyset-test"}) rows=5159701
        2022-12-13T16:03:11.155418Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "readyset-test"}) rows_replicated=1246402
        2022-12-13T16:03:19.927790Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "readyset-test"}) rows_replicated=1126400 progress=21.83% estimate=00:01:51
        ...
        ```

=== "RDS MySQL"

    1. Connect the [`mysql` shell](https://www.postgresql.org/docs/current/app-psql.html) to ReadySet, replacing placeholders with your ReadySet connection details:

        ``` sh
        mysql \
        --host=<readyset_address> \
        --port=6033 \
        --user=<readyset_username> \
        --password=<readyset_password> \
        --database=<db_name>
        ```

        !!! tip

            To find the public address of the EC2 instance where ReadySet is running, select your instance in the EC2 Console, and look for **Public IPv4 DNS**.

        You should now be in the SQL shell.

    1. Use ReadySet's custom [`SHOW READYSET TABLES`](../cache/check-snapshotting.md#check-overall-status) command to check the snapshotting status of tables in the database ReadySet is connected to:

        ``` sql
        SHOW READYSET TABLES;
        ```

        ``` {.text .no-copy}
                 table            |    status
        ------------------------------------------
        `public`.`title_basics`   | Snapshotting
        `public`.`title_ratings`  | Snapshotted
        `public`.`title_episodes` | Not Replicated
        (3 rows)
        ```

        There are 3 possible statuses:

        - **Snapshotting:** The initial snapshot of the table is in progress.
        - **Snapshotted:** The initial snapshot of the table is complete. ReadySet is replicating changes to the table via the database's replication stream.
        - **Not Replicated:** The table has not been snapshotted by ReadySet. This can be because ReadySet encountered an error (e.g., due to [unsupported data types](../../reference/sql-support.md#data-types)) or the table has been intentionally excluded from snapshotting (via the [`--replication-tables`](../../reference/cli/readyset.md#-replication-tables) option).

        !!! info

            You can start [caching queries]((../cache/cache-queries.md#cache-queries_1) in ReadySet only once all tables with the `Snapshotting` status have finished snapshotting and show the `Snapshotted` status.

    1. If you'd like to track snapshotting progress in greater detail, exit the SQL shell, SSH to the machine where ReadySet is running, and then check the ReadySet logs:

        ``` sh
        grep 'taking database snapshot' logs/readyset.log
        ```

        !!! note

            For each table, you'll see the progress and the estimated time remaining in the log messages (e.g., `progress=84.13% estimate=00:00:23`).

        ``` {.text .no-copy}
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

## Next steps

- Connect your app

    The next step is to connect your application by swapping out your database connection string to point to ReadySet instead. The specifics of how to do this vary by database client library, ORM, and programming language. See [Connect an App](../connect/existing-app.md) for examples.

    !!! note

        By default, ReadySet will proxy all queries to the database, so changing your app to connect to ReadySet should not impact performance. You will explicitly tell ReadySet which queries to cache.   

- Profile and cache queries

    Once you are running queries against ReadySet, connect a database SQL shell to ReadySet and use the custom [`SHOW PROXIED QUERIES`]((../cache/cache-queries.md#check-query-support) SQL command to view the queries that ReadySet has proxied to your upstream database and identify which queries are supported by ReadySet. Then use the custom [`CREATE CACHE`]((../cache/cache-queries.md#cache-queries_1) SQL command to cache supported queries.

    !!! note

        To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../../reference/sql-support.md).

- Set up monitoring

    ReadySet outputs time series metrics at `0.0.0.0:6034/metrics`. The metrics are formatted for easy integration with [Prometheus](https://prometheus.io/), an open source tool you can use to for storing, aggregating, and querying time series data. You can use this data to, for example, profile SQL query latencies and identify queries to cache with ReadySet.
