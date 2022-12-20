# Quickstart with ReadySet

This page shows you how to run ReadySet locally against an existing Postgres or MySQL database.

!!! tip

    For a demonstration of ReadySet's capabilities and features, see the [ReadySet Demo](demo.md) instead.

## Before you begin

If you don't have an existing database to run ReadySet against, start [Docker](https://docs.docker.com/engine/install/) and run the following command to create a new, empty database:

=== "Postgres"

    ``` sh
    docker run -d \
    --name=postgres \
    --publish=5432:5432 \
    -e POSTGRES_PASSWORD=readyset \
    -e POSTGRES_DB=imdb \
    postgres:14 \
    -c wal_level=logical
    ```

=== "MySQL"

    ``` sh

    ```

## Step 1. Configure your database

ReadySet uses your database's replication stream to automatically keep your cache up-to-date as the database changes. In Postgres, the replication stream is called [logical replication](https://www.postgresql.org/docs/current/logical-replication.html). In MySQL, the replication stream is called the [binary log](https://dev.mysql.com/doc/refman/5.7/en/binary-log.html).

In this step, you'll ensure replication is enabled.

=== "Postgres"

    1. Connect the `psql` shell to your database, replacing placeholders with your database connection details:

        ``` sh
        PGPASSWORD=<password> psql \
        --host=localhost \
        --port=5432 \
        --username=<username> \
        --dbname=<database_name>
        ```

    1. Check if logical replication is enabled:

        ``` sql
        SELECT name,setting
          FROM pg_settings
          WHERE name = 'wal_level';
        ```

        If `wal_level` is set to `logical`, you're all set; skip to [Step 2](#step-2-connect-readyset):

        ``` {.text .no-copy}
            name    | setting
         -----------+---------
          wal_level | logical
         (1 row)
        ```

        If `wal_level` is set to any other value (for example, `replica`), continue to the next step:

        ``` {.text .no-copy}
            name    | setting
         -----------+---------
          wal_level | replica
         (1 row)
        ```

    1. Stop the database.

    1. Restart the database with logical replication enabled:

        ``` sh
        postgres -c wal_level=logical <other flags>
        ```

        Alternately, you can add the following to the `postgresql.conf` file and then restart the database:

        ``` sh
        wal_level = logical
        ```

=== "MySQL"


## Step 2. Connect ReadySet


=== "Docker"

Make sure you have [Docker](https://docs.docker.com/engine/install/) installed and running.

=== "Binary"

Now that you have a live database with sample data, you'll connect ReadySet to the database and watch it take a snapshot of your tables. This snapshot will be the basis for ReadySet to cache query results, and ReadySet will keep its snapshot and cache up-to-date automatically by listening to the database's replication stream.

1. Create a third container and start ReadySet inside it, connecting ReadySet to your Postgres database via the connection string in `--upstream-db-url`:

    ``` sh
    docker run -d \
    --name=readyset \
    --publish=5433:5433 \
    --network=readyset-net \
    --platform=linux/amd64 \
    --volume='readyset:/state' \
    --pull=always \
    -e DEPLOYMENT_ENV=quickstart_docker \
    -e RSA_API_KEY \
    public.ecr.aws/readyset/readyset:latest \
    --standalone \
    --deployment='quickstart-postgres' \
    --database-type=postgresql \
    --upstream-db-url=postgresql://postgres:readyset@postgres:5432/imdb \
    --address=0.0.0.0:5433 \
    --username='postgres' \
    --password='readyset' \
    --query-caching='explicit' \
    --db-dir='/state'
    ```

2. This `docker run` command is similar to the one you used to start Postgres. However, the flags following the `readyset` image are specific to ReadySet. Take a moment to understand them:

    Flag | Details
    -----|--------
    `-e` |  For this tutorial, you also set an environment variable to allow ReadySet to categorize your deployment as a quickstart experience in anonymous [telemetry](../reference/telemetry.md) data.
    `--standalone` | <p>For [production deployments](deploy-readyset-kubernetes.md), you run the ReadySet Server and Adapter as separate processes. For local testing, however, you can run the Server and Adapter as a single process by passing the `--standalone` flag to the `readyset` command.</p>
    `--deployment` | A unique identifier for the ReadySet deployment.
    `--database-type` | The `readyset` image works with both Postgres and MySQL. You set this flag to specify which one you're using.
    `--upstream-db-url` | <p>The URL for connecting ReadySet to Postgres. This connection URL includes the username and password for ReadySet to authenticate with as well as the database to replicate.</p><div class="admonition tip"><p class="admonition-title">Tip</p><p>By default, ReadySet replicates all tables in all schemas of the specified Postgres database. For this tutorial, that's fine. However, in future deployments, if the queries you want to cache access only a specific schema or specific tables in a schema, or if some tables can't be replicated by ReadySet because they contain [data types](../reference/sql-support/#data-types) that ReadySet does not support, you can narrow the scope of replication by passing `--replication-tables=<schema.table>,<schema.table>`.</p>
    `--address` | The IP and port that ReadySet listens on. For this tutorial, ReadySet is running locally on a different port than Postgres, so connecting `psql` to ReadySet is just a matter of changing the port from `5432` to `5433`.</p>       
    `--username`<br>`--password`| The username and password for connecting clients to ReadySet. For this tutorial, you're using the same username and password for both Postgres and ReadySet.
    `--query-caching` | <p>The query caching mode for ReadySet.</p><p>For this tutorial, you've set this to `explicit`, which means you must run a specific command to have ReadySet cache a query (covered in [Step 3](#step-3-cache-queries)). The other options are `inrequestpath` and `async`. `inrequestpath` caches [supported queries](../reference/sql-support/#query-caching) automatically but blocks queries from returning results until the cache is ready. `async` also caches supported queries automatically but proxies queries to the upstream database until the cache is ready. For most deployments, the `explicit` option is recommended, as it gives you the most flexibility and control.</p>
    `--db-dir` | The directory in which to store replicated table data. For this tutorial, you're using a Docker volume that will persist after the container is stopped.

3. Watch as ReadySet takes a snapshot of your tables:

    !!! note

        Snapshotting will take a few minutes. For each table, you'll see the progress and the estimated time remaining in the log messages (e.g., `progress=84.13% estimate=00:00:23`).

    ``` sh
    docker logs readyset | grep 'Snapshotting table'
    ```

    ``` {.text .no-copy}
    2022-12-13T16:02:48.142605Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "quickstart-postgres"})
    2022-12-13T16:02:48.202895Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "quickstart-postgres"})
    2022-12-13T16:02:48.357445Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "quickstart-postgres"}) rows=1246402
    2022-12-13T16:02:48.921839Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "quickstart-postgres"}) rows=5159701
    2022-12-13T16:03:11.155418Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=1246402
    2022-12-13T16:03:19.927790Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=1126400 progress=21.83% estimate=00:01:51
    2022-12-13T16:03:50.933060Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=2282496 progress=44.24% estimate=00:01:18
    2022-12-13T16:04:21.932289Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=3433014 progress=66.54% estimate=00:00:46
    2022-12-13T16:04:52.932615Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=4604034 progress=89.23% estimate=00:00:14
    2022-12-13T16:05:07.837214Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=5159701
    ```

    Don't continue to the next step until you see `Snapshotting finished` for both `title_ratings` and `title_basics`:

    ``` sh
    docker logs readyset | grep 'Snapshotting finished'
    ```

    ``` {.text .no-copy}
    2022-12-13T16:03:11.155418Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=1246402
    2022-12-13T16:05:07.837214Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=5159701
    ```

## Step 3. Run some queries

## Next steps

- [Connect an app](connect-an-app.md)

- [Review query support](../reference/sql-support.md)

- [Learn how ReadySet works under the hood](../concepts/overview.md)

- [Deploy with ReadySet Cloud](deploy-readyset-cloud.md)
