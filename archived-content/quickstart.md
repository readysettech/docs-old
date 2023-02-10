# Quickstart with ReadySet

This page shows you how to run ReadySet against a Postgres or MySQL database.

!!! tip

    For a walk-through of ReadySet's capabilities and features, see the [ReadySet Demo](tutorial.md) instead.

## Before you begin

- Install and start [Docker](https://docs.docker.com/engine/install/) for your OS.
- Install the [`psql` shell](https://www.postgresql.org/docs/current/app-psql.html) or the [`mysql` shell](https://dev.mysql.com/doc/refman/8.0/en/mysql.html).

## Step 1. Configure your database

=== "Use a new database"

    If you don't already have a Postgres or MySQL database running locally, start a new database and load some sample data.

    === "Postgres"

        1. Create a Docker container and start Postgres inside it:

            ``` sh
            docker run -d \
            --name=postgres \
            --publish=5432:5432 \
            -e POSTGRES_PASSWORD=readyset \
            -e POSTGRES_DB=testdb \
            postgres:14 \
            -c wal_level=logical
            ```

            This command starts the database with the correct configuration for ReadySet.

        1. Download a sample data file:

            ``` sh
            curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-data-postgres.sql
            ```

        1. Connect the `psql` shell to your database:

            ``` sh
            PGPASSWORD=readyset psql \
            --host=127.0.0.1 \
            --port=5432 \
            --username=postgres \
            --dbname=testdb
            ```

        1. Load the sample data into your database:

            ``` sh
            \i quickstart-data-postgres.sql
            ```

    === "MySQL"

        1. Create a Docker container and start MySQL inside it:

            ``` sh
            docker run -d \
            --name=mysql \
            --publish=3306:3306 \
            -e MYSQL_ROOT_PASSWORD=readyset \
            -e MYSQL_DATABASE=testdb \
            mysql
            ```

            This command starts the database with the correct configuration for ReadySet.

        1. Download a sample data file:

            ``` sh
            curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-data-mysql.sql
            ```

        1. Connect the `mysql` shell to your database:

            ``` sh
            mysql \
            --host=127.0.0.1 \
            --port=3306 \
            --user=root \
            --password=readyset \
            --database=testdb
            ```

        1. Load the sample data into your database:

            ``` sh
            source quickstart-data-mysql.sql;
            ```

=== "Use an existing database"

    ReadySet uses your database's replication stream to automatically keep your cache up-to-date as the database changes. In this step, you'll ensure replication is enabled.

    === "Postgres"

        1. Connect the `psql` shell to your database, replacing the example values with your database connection details:

            ``` sh
            PGPASSWORD=readyset psql \
            --host=127.0.0.1 \
            --port=5432 \
            --username=postgres \
            --dbname=testdb
            ```

        1. Check if [replication](https://www.postgresql.org/docs/current/logical-replication.html) is enabled:

            ``` sql
            SELECT name,setting
              FROM pg_settings
              WHERE name = 'wal_level';
            ```

            If `wal_level` is `logical`, you're all set; skip to [Step 2](#step-2-start-readyset):

            ``` {.text .no-copy}
                name    | setting
             -----------+---------
              wal_level | logical
             (1 row)
            ```

            If `wal_level` is set to any other value (for example, `replica`), continue to the next step.

        1. Stop the database.

        1. Restart the database with replication enabled:

            ``` sh
            postgres -c wal_level=logical <other options>
            ```

            Alternately, you can add the following to the `postgresql.conf` file and then restart the database:

            ``` sh
            wal_level = logical
            ```

    === "MySQL"

        1. Connect the `mysql` shell to your database, replacing the example values with your database connection details:

            ``` sh
            mysql \
            --host=127.0.0.1 \
            --port=3306 \
            --user=root \
            --password=readyset \
            --database=testdb
            ```

        1. Check if [replication](https://dev.mysql.com/doc/refman/5.7/en/replication.html) is enabled with the `ROW` logging format:

            ``` sql
            SHOW VARIABLES LIKE 'log_bin';
            SHOW VARIABLES LIKE 'binlog_format';
            ```

            If `log_bin` is `ON` and `binlog_format` is `ROW`, you're all set; skip to [Step 2. Start ReadySet](#step-2-start-readyset):

            ``` {.text .no-copy}
            +---------------+-------+
            | Variable_name | Value |
            +---------------+-------+
            | log_bin       | ON    |
            +---------------+-------+
            1 row in set (0.01 sec)

            +---------------+-------+
            | Variable_name | Value |
            +---------------+-------+
            | binlog_format | ROW   |
            +---------------+-------+
            1 row in set (0.01 sec)
            ```

            If either is set to any other value, continue to the next step.

        1. Stop the database.

        1. Restart the database with replication enabled and the logging format set to `ROW`:

            ``` sh
            mysql --log-bin --binlog-format=ROW <other options>
            ```

## Step 2. Start ReadySet

=== "Use a new database"

    Create a Docker container and start ReadySet inside it, connecting ReadySet to the database via the connection string in `--upstream-db-url`:

    === "Postgres"

        ``` sh
        docker run -d \
        --name=readyset \
        --publish=5433:5433 \
        --platform=linux/amd64 \
        --volume='readyset:/state' \
        --pull=always \
        -e DEPLOYMENT_ENV=quickstart_docker \
        -e RS_API_KEY \
        public.ecr.aws/readyset/readyset:beta-2023-01-18 \
        --standalone \
        --deployment='quickstart-postgres' \
        --database-type=postgresql \
        --upstream-db-url=postgresql://postgres:readyset@172.17.0.1:5432/testdb \
        --address=0.0.0.0:5433 \
        --username='postgres' \
        --password='readyset' \
        --query-caching='explicit' \
        --db-dir='/state'
        ```

    === "MySQL"

        ``` sh
        docker run -d \
        --name=readyset \
        --publish=3307:3307 \
        --platform=linux/amd64 \
        --volume='readyset:/state' \
        --pull=always \
        -e DEPLOYMENT_ENV=quickstart_docker \
        -e RS_API_KEY \
        public.ecr.aws/readyset/readyset:beta-2023-01-18 \
        --standalone \
        --deployment='quickstart-mysql' \
        --database-type=mysql \
        --upstream-db-url=mysql://root:readyset@172.17.0.1:3306/testdb \
        --address=0.0.0.0:5433 \
        --username='root' \
        --password='readyset' \
        --query-caching='explicit' \
        --db-dir='/state'
        ```

=== "Use an existing database"

    Create a Docker container and start ReadySet inside it:

    !!! note

        Be sure to update `--upstream-db-url`, `--username` and `--password` with your database connection string and credentials.

    === "Postgres"

        ``` sh
        docker run -d \
        --name=readyset \
        --publish=5433:5433 \
        --platform=linux/amd64 \
        --volume='readyset:/state' \
        --pull=always \
        -e DEPLOYMENT_ENV=quickstart_docker \
        -e RS_API_KEY \
        public.ecr.aws/readyset/readyset:beta-2023-01-18 \
        --standalone \
        --deployment='quickstart-postgres' \
        --database-type=postgresql \
        --upstream-db-url=postgresql://postgres:readyset@172.17.0.1:5432/testdb \
        --address=0.0.0.0:5433 \
        --username='postgres' \
        --password='readyset' \
        --query-caching='explicit' \
        --db-dir='/state'
        ```

    === "MySQL"

        ``` sh
        docker run -d \
        --name=readyset \
        --publish=3307:3307 \
        --platform=linux/amd64 \
        --volume='readyset:/state' \
        --pull=always \
        -e DEPLOYMENT_ENV=quickstart_docker \
        -e RS_API_KEY \
        public.ecr.aws/readyset/readyset:beta-2023-01-18 \
        --standalone \
        --deployment='quickstart-mysql' \
        --database-type=mysql \
        --upstream-db-url=mysql://root:readyset@172.17.0.1:3306/testdb \
        --address=0.0.0.0:5433 \
        --username='root' \
        --password='readyset' \
        --query-caching='explicit' \
        --db-dir='/state'
        ```

For details about the `readyset` command options, see the [ReadySet Demo](tutorial.md#step-2-start-readyset) or the [CLI reference docs](../reference/cli/readyset.md).

## Next steps

- Connect an app

    Once you have a ReadySet instance up and running, the next step is to connect your application by swapping out your database connection string to point to ReadySet instead. The specifics of how to do this vary by database client library, ORM, and programming language. See [Connect an App](connect-an-app.md) for examples.

    !!! note

        By default, ReadySet will proxy all queries to the database, so changing your app to connect to ReadySet should not impact performance. You will explicitly tell ReadySet which queries to cache.   

- Profile and cache queries

    Once you are running queries against ReadySet, connect a database SQL shell to ReadySet and use the custom [`SHOW PROXIED QUERIES`](cache-queries.md#identify-queries-to-cache) SQL command to view the queries that ReadySet has proxied to your upstream database and identify which queries are supported by ReadySet. Then use the custom [`CREATE CACHE`](cache-queries.md#cache-queries_1) SQL command to cache supported queries.

    !!! note

        To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../reference/sql-support.md).

- Tear down

    When you are done testing, stop and remove the ReadySet container and volume:

    ```
    docker rm -f readyset \
    && docker volume rm readyset
    ```

    If you started a new database, also stop and remove its container:

    === "Postgres"

        ```
        docker rm -f postgres
        ```

    === "MySQL"

        ```
        docker rm -f mysql
        ```
