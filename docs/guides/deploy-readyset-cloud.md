# Deploy with ReadySet Cloud

This page shows you how to get up and running with a fully-managed deployment of ReadySet on ReadySet Cloud.

!!! tip

    If you are new to ReadySet, consider running through the [Quickstart](quickstart.md) or [Demo](tutorial.md) first.

## Before you begin

- Note that ReadySet Cloud can integrate with:

    - [Amazon RDS for Postgres](https://aws.amazon.com/rds/postgresql/)
    - [Amazon RDS for MySQL](https://aws.amazon.com/rds/mysql/)
    - [Supabase](https://supabase.com/)

    If you want to integrate with another variant of Postgres or MySQL, please [contact ReadySet](mailto:info@readyset.io).

- Note that ReadySet does not currently support [row-level security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html). Make sure any RLS policies are disabled.

- For Amazon RDS for Postgres and Supabase, make sure tables without primary keys have [`REPLICA IDENTITY FULL`](https://www.postgresql.org/docs/current/sql-altertable.html#SQL-ALTERTABLE-REPLICA-IDENTITY) before connecting ReadySet. Otherwise, Postgres will block writes and deletes on those tables.

## Step 1. Get early access

ReadySet Cloud is currently in closed beta.

[Get early access to ReadySet Cloud](https://readysettech.typeform.com/to/BqovNk8A?typeform-source=readyset.io){ .md-button .md-button--primary }

## Step 2. Collect required details

Once you've signed up, ReadySet will schedule time to discuss your use case, give you an overview of the onboarding process, and ask for required details about your database. Please collect these details ahead of the call.

=== "RDS Postgres"

    1. [Get your AWS account ID](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html).
    1. Get your AWS region:
        1. In the RDS Console, go to **Databases**.
        1. Select your database.
        1. In the **Summary** area, note the **Region & AZ**.
    1. Get your database connection string:
        1. In the **Connectivity & security** area, note the **Endpoint**.
    1. Get the version of Postgres you are using:
        1. Click the **Configuration** tab.
        1. In the **Instance** area, note the **Engine version**.
    1. Get the the ID and CIDR of your database's VPC:
        1. Click the **Connectivity & security** tab.
        1. In the **Connectivity & security** area, click the VPC ID.
        1. Note the **VPC ID**.
        1. Note the **IPv4 CIDR**.
    1. Share all collected details during your call with ReadySet.

=== "RDS MySQL"

    1. [Get your AWS account ID](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html).
    1. Get your AWS region:
        1. In the RDS Console, go to **Databases**.
        1. Select your database.
        1. In the **Summary** area, note the **Region & AZ**.
    1. Get your database connection string:
        1. In the **Connectivity & security** area, note the **Endpoint**.
    1. Get the version of MySQL you are using:
        1. Click the **Configuration** tab.
        1. In the **Instance** area, note the **Engine version**.
    1. Get the the ID and CIDR of your database's VPC:
        1. Click the **Connectivity & security** tab.
        1. In the **Connectivity & security** area, click the VPC ID.
        1. Note the **VPC ID**.
        1. Note the **IPv4 CIDR**.
    1. Share all collected details during your call with ReadySet.

=== "Supabase"

    1. Get your AWS region:
        1. In the Supabase Dashboard, go to **Project Settings > General**.
        1. Scroll to the **Infrastructure** area.
        1. Note the **Region**.
    1. Get your database connection string:
        1. Scroll down to the **Connection string** area.
        1. Select **URI** and note the connection string.

            !!! warning

                Be sure to note the connection string under **Connection string**, not under **Connection pooling**. To verify that you have the correct one, check for port `5432`.
    1. Share all collected details during your call with ReadySet.

## Step 3. Configure your database

ReadySet uses your database's replication stream to automatically keep your cache up-to-date as the database changes.

On your call with ReadySet, you'll ensure replication is enabled. The steps are provided here for convenience.

=== "RDS Postgres"

    1. Connect the `psql` shell to your database, replacing placeholders with your database connection details:

        ``` sh
        PGPASSWORD=<password> psql \
        --host=<database_endpoint> \ # (1)
        --port=<port> \
        --username=<username> \
        --dbname=<database_name>
        ```

        1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

    1. Check if [replication](https://www.postgresql.org/docs/current/logical-replication.html) is enabled:

        ``` sql
        SELECT name,setting
          FROM pg_settings
          WHERE name = 'rds.logical_replication';
        ```

        If replication is already on, skip to [Step 4](#step-4-cache-queries):

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

    1. Back in the SQL shell, verify that replication is now enabled:

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

    Following your call with ReadySet, ReadySet will start your deployment.

    - At first, ReadySet will take a snapshot of your data, which can take between a few minutes to several hours, depending on the size of your dataset.

        !!! warning

            Make sure there are no DDL statements in progress. Until the entire snapshot is finished, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked.

    - Once snapshotting is finished, ReadySet will send you the ReadySet connection string.

=== "RDS MySQL"

    1. In RDS MySQL, [replication](https://dev.mysql.com/doc/refman/5.7/en/replication.html) is enabled only when automated backups are also enabled. If you didn't enable automated backups when creating your database instance, [enable automated backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html#USER_WorkingWithAutomatedBackups.Enabling) now.

        - Be sure to use the **Apply Immediately** option. The database must be rebooted in order for the change to take effect.

        - Do not move on to the next step until the database **Status** is **Available** in the RDS Console.

    1. Connect the `mysql` shell to your database, replacing placeholders with your database connection details:

        ``` sh
        mysql \
        --host=<database_endpoint> \ # (1)
        --port=<port> \
        --user=<username> \
        --password=<password> \
        --database=<database_name>
        ```

        1.  To find the database endpoint, select your database in the RDS Console, and look under **Connectivity & security**.

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

        If the binary logging format is `ROW`, skip to [Step 4](#step-4-cache-queries):

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

    Following your call with ReadySet, ReadySet will start your deployment.

    - At first, ReadySet will take a snapshot of your data, which can take between a few minutes to several hours, depending on the size of your dataset.

        !!! warning

            Make sure there are no DDL statements in progress. Until the entire snapshot is finished, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked. In MySQL, `INSERT` and `UPDATE` statements will also be blocked, but only while a given table is being snapshotted.

    - Once snapshotting is finished, ReadySet will send you the ReadySet connection string.

=== "Supabase"

    In Supabase, [replication](https://www.postgresql.org/docs/current/logical-replication.html) is already enabled. However, you must change the `postgres` user's permissions so that ReadySet can create a replication slot.  

    1. In the Supabase Dashboard, go to the **SQL Editor**.

    1. Change the `postgres` user's permissions to `SUPERUSER`:

        ``` sql
        ALTER USER postgres WITH SUPERUSER;
        ```

    Following your call with ReadySet, ReadySet will start your deployment.

    - At first, ReadySet will take a snapshot of your data, which can take between a few minutes to several hours, depending on the size of your dataset.

        !!! warning

            Make sure there are no DDL statements in progress. Until the entire snapshot is finished, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked.

    - Once snapshotting is finished, ReadySet will send you the ReadySet connection string.

## Step 4. Cache queries

1. Once you have the ReadySet connection string, update your app to connect to ReadySet instead of the upstream database. See [Connect an App](connect-an-app.md) for client library and ORM examples.

    !!! note

        By default, ReadySet will proxy all queries to the upstream database, so changing your app to connect to ReadySet should not impact performance. You will explicitly tell ReadySet which queries to cache.   

2. Use your preferred monitoring tool to identify slow queries.

3. For each query you want to cache:

    1. Connect the `psql` shell to your ReadySet Cloud instance, using the connection string that ReadySet provided:

        ``` sh
        psql '<ReadySet connection string>'
        ```

    2. Run ReadySet's custom [`SHOW PROXIED QUERIES`](cache-queries.md#identify-queries-to-cache) command:

        ``` sql
        SHOW PROXIED QUERIES;
        ```

    3. In the command output, find the query and check the `readyset supported` value:

        - If the value is `pending`, check again until you see `yes` or `no`.
        - If the value is `yes`, ReadySet can cache the query.
        - If the value is `no`, ReadySet cannot cache the query.

            !!! note

                To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../reference/sql-support/#query-caching). If an unsupported feature is important to your use case, [submit a feature request](https://github.com/readysettech/readyset/issues/new/choose).

    4. If the query is supported, use ReadySet's custom [`CREATE CACHE`](cache-queries.md#cache-queries_1) command to cache the query results in ReadySet:

        ``` sql
        CREATE CACHE FROM <query>; -- (1)
        ```

        1.   You can provide either the full `SELECT` text or the query ID listed in the `SHOW PROXIED QUERIES` output.

        Caching will take a few minutes, as it constructs the initial dataflow graph for the query and adds indexes to the relevant ReadySet table snapshots, as necessary. The `CREATE CACHE` command will return once this is complete.    

    5. Use ReadySet's custom [`SHOW CACHES`](cache-queries.md#view-cached-queries) command to verify that the cache has been created for your query:

        ``` sql
        SHOW CACHES;
        ```

4. Use your preferred monitoring tool to check how fast results are now returning for your cached queries.

## Next steps

- Use your **private Slack channel** to report issues or ask questions. This Slack channel was created for you during your onboarding call with ReadySet.
- Join the [Discord chat](https://discord.gg/readyset) to interact with the broader ReadySet community.
