# ReadySet Demo

This page walks you through an end-to-end local deployment of ReadySet.

- First, you'll start a Postgres database and load sample data into it.
- Next, you'll connect ReadySet, cache some queries, and test how fast ReadySet returns results compared to Postgres.
- Finally, you'll write to the database and see how ReadySet keeps your cache up-to-date automatically, with no changes to your application code.

<a class="md-button md-button--primary" href="../tutorial-interactive/" target="_blank" rel="noopener">Run this in your browser &rarr;</a>

## Before you begin

Make sure you have [Docker](https://docs.docker.com/engine/install/) installed and running.

## Step 1. Start the database

ReadySet sits between your database and application, so in this step, you'll start up a local instance of Postgres and load two sample tables from the [IMDb dataset](https://www.imdb.com/interfaces/).

1. Since you'll be running multiple Docker containers on a single host, create a bridge network for the containers to share:

    ``` sh
    docker network create -d bridge readyset-net
    ```

1. Create a new container and start Postgres inside it:

    ``` sh
    docker run -d \
    --name=postgres \
    --publish=5432:5432 \
    --network=readyset-net \
    -e POSTGRES_PASSWORD=readyset \
    -e POSTGRES_DB=imdb \
    postgres:14 \
    -c wal_level=logical
    ```

1. Take a moment to understand the options you used:

    <style>
      table thead tr th:first-child {
        width: 150px;
      }
    </style>

    Flag | Details
    -----|--------
    `-d` | Runs the container in the background so you can continue the next steps in the same terminal.
    `--name` | Assigns a name to the container so you can easily reference it later in Docker commands.
    `--publish` | Maps the Postgres port from the container to the host so you can access the database from outside of Docker.
    `--network` | Connects the container to the bridge network you created earlier.
    `-e` | Sets environment variables to create a password for the default `postgres` user and to create a database. You'll use these details when connecting to Postgres.
    `-c` |  Turns on Postgres [logical replication](https://www.postgresql.org/docs/current/logical-replication.html). Once ReadySet has taken an initial snapshot of the database, it uses the replication stream to keep its snapshot and caches up-to-date as the database changes. You'll see this in action in [Step 6](#step-6-cause-a-cache-refresh).   

1. Create a second container for downloading sample data and running the `psql` client:

    ``` sh
    docker run -dit \
    --name=psql \
    --network=readyset-net \
    postgres:14 \
    bash
    ```

1. Get into the container and install some dependencies for downloading the sample data:

    ``` sh
    docker exec -it psql bash
    ```

    ``` sh
    apt-get update \
    && apt-get -y install curl unzip
    ```

1. Download CSV files containing data for these tables from the [IMDb dataset](https://www.imdb.com/interfaces/):

    ``` sh
    curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart_sample_data.zip \
    && unzip quickstart_sample_data.zip
    ```

1. Use the `psql` client to create the schema for 2 tables, `title_basics` and `title_ratings`:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb \
    -c "CREATE TABLE title_basics (
          tconst TEXT PRIMARY KEY,
          titletype TEXT,
          primarytitle TEXT,
          originaltitle TEXT,
          isadult BOOLEAN,
          startyear INT,
          endyear INT,
          runtimeminutes INT,
          genres TEXT
        );"
    ```

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb \
    -c "CREATE TABLE title_ratings (
          tconst TEXT PRIMARY KEY,
          averagerating NUMERIC,
          numvotes INT
        );"
    ```

1. Load the data into each table:

    !!! note

        These commands may take a few minutes, as they load 5159701 rows into `title_basics` and 1246402 rows into `title_ratings`.

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb \
    -c "\copy title_basics
        from 'title_basics.tsv'
        with DELIMITER E'\t'"
    ```

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb \
    -c "\copy title_ratings
        from 'title_ratings.tsv'
        with DELIMITER E'\t'"
    ```

1. Open the `psql` shell and get a sense of the data in each table:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb
    ```

    ``` sql
    SELECT count(*) FROM title_basics;
    SELECT * FROM title_basics WHERE tconst = 'tt0093779';
    ```

    ``` {.text .no-copy}
      count
    ---------
     5159701
    (1 row)

      tconst   | titletype |    primarytitle    |   originaltitle    | isadult | startyear | endyear | runtimeminutes |          genres
    -----------+-----------+--------------------+--------------------+---------+-----------+---------+----------------+--------------------------
     tt0093779 | movie     | The Princess Bride | The Princess Bride | f       |      1987 |         |             98 | Adventure,Family,Fantasy
    (1 row)
    ```

    ``` sql
    SELECT count(*) FROM title_ratings;
    SELECT * FROM title_ratings WHERE tconst = 'tt0093779';
    ```

    ``` {.text .no-copy}
      count
    ---------
     1246402
    (1 row)

      tconst   | averagerating | numvotes
    -----------+---------------+----------
     tt0093779 |           8.0 |   427192
    (1 row)    
    ```

1. Exit the `psql` shell and container:

    ``` sql
    \q
    ```

    ``` sh
    exit
    ```

## Step 2. Start ReadySet

Now that you have a live database with sample data, you'll connect ReadySet to the database.

1. Create a third container and start ReadySet inside it, connecting ReadySet to your Postgres database via the connection string in `--upstream-db-url`:

    ``` sh
    docker run -d \
    --name=readyset \
    --publish=5433:5433 \
    --publish=6034:6034 \
    --network=readyset-net \
    --platform=linux/amd64 \
    --volume='readyset:/state' \
    --pull=always \
    -e DEPLOYMENT_ENV=tutorial_docker \
    -e RS_API_KEY \
    public.ecr.aws/readyset/readyset:beta-2023-01-18 \
    --standalone \
    --deployment='tutorial-postgres' \
    --database-type=postgresql \
    --upstream-db-url=postgresql://postgres:readyset@postgres:5432/imdb \
    --address=0.0.0.0:5433 \
    --username='postgres' \
    --password='readyset' \
    --query-caching='explicit' \
    --db-dir='/state' \
    --query-log \
    --query-log-ad-hoc
    ```

1. This `docker run` command is similar to the one you used to start Postgres. However, the options following the `readyset` image are specific to ReadySet. Take a moment to understand them:

    Flag | Details
    -----|--------
    `-e` |  For this tutorial, you also set an environment variable to allow ReadySet to categorize your deployment as a quickstart experience in anonymous [telemetry](../reference/telemetry.md) data.
    `--standalone` | <p>For [production deployments](deploy-readyset-kubernetes.md), you run the ReadySet Server and Adapter as separate processes. For local testing, however, you can run the Server and Adapter as a single process by passing the `--standalone` flag to the `readyset` command.</p>
    `--deployment` | A unique identifier for the ReadySet deployment.
    `--database-type` | The `readyset` image works with both Postgres and MySQL. You set this flag to specify which one you're using.
    `--upstream-db-url` | <p>The URL for connecting ReadySet to Postgres. This connection URL includes the username and password for ReadySet to authenticate with as well as the database to snapshot and replicate.</p><div class="admonition tip"><p class="admonition-title">Tip</p><p>By default, ReadySet attempts to snapshot and replicate all tables in all schemas of the specified Postgres database. For this tutorial, that's fine. However, in future deployments, if the queries you want to cache access only a subset of tables, you can use the [`--replication-tables`](../reference/cli/readyset.md#-replication-tables) option to filter out other tables that will not be used in caches. This will speed up the snapshotting process.</p>
    `--address` | The IP and port that ReadySet listens on. For this tutorial, ReadySet is running locally on a different port than Postgres, so connecting `psql` to ReadySet is just a matter of changing the port from `5432` to `5433`.</p>       
    `--username`<br>`--password`| The username and password for connecting clients to ReadySet. For this tutorial, you're using the same username and password for both Postgres and ReadySet.
    `--query-caching` | <p>The query caching mode for ReadySet.</p><p>For this tutorial, you've set this to `explicit`, which means you must run a specific command to have ReadySet cache a query (covered in [Step 4](#step-4-cache-queries)). The other options are `inrequestpath` and `async`. `inrequestpath` caches [supported queries](../reference/sql-support/#query-caching) automatically but blocks queries from returning results until the cache is ready. `async` also caches supported queries automatically but proxies queries to the upstream database until the cache is ready. For most deployments, the `explicit` option is recommended, as it gives you the most flexibility and control.</p>
    `--db-dir` | The directory in which to store replicated table data. For this tutorial, you're using a Docker volume that will persist after the container is stopped.
    `--query-log`<br>`--query-log-ad-hoc` | Enables logging individual queries and exposes per-query execution metrics at the `/metrics` endpoint.

    !!! tip

        For more details about the `readyset` command options, see the [CLI reference docs](../reference/cli/readyset.md).

## Step 3. Check snapshotting

As soon as ReadySet connects to the database, it starts storing a snapshot of your database tables on disk. This snapshot will be the basis for ReadySet to cache query results, and ReadySet will keep its snapshot and cache up-to-date automatically by listening to the database's replication stream.

Snapshotting can take between a few minutes to several hours, depending on the size of your dataset. In this tutorial, snapshotting should take just a few minutes. Check the status of snapshotting, and make sure it's complete, before continuing to the next step.

1. Get back into the `psql` container and connect it to ReadySet instead of the database:

    ``` sh
    docker exec -it psql bash
    ```

    ``` sh
    PGPASSWORD=readyset psql \
    --host=readyset \
    --port=5433 \
    --username=postgres \
    --dbname=imdb
    ```

1. Use ReadySet's custom [`SHOW READYSET TABLES`](check-snapshotting.md#check-overall-status) command to check the snapshotting status of tables in the database ReadySet is connected to:

    ``` sql
    SHOW READYSET TABLES;
    ```

    ``` {.text .no-copy}
             table            |    status
    --------------------------+--------------
     `public`.`title_basics`  | Snapshotting
     `public`.`title_ratings` | Snapshotting
     (2 rows)
    ```

    At first, the status will be `Snapshotting`. Don't continue to the next step until you see `Snapshotted` for both `title_basics` and `title_ratings`.

    If you'd like to track snapshotting progress in greater detail:

    1. Exit the `psql` shell and container:

        ``` sql
        \q
        ```

        ``` sh
        exit
        ```

    1. Check the ReadySet logs:

        !!! note

            For each table, you'll see the progress and the estimated time remaining in the log messages (e.g., `progress=84.13% estimate=00:00:23`).

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

        Again, don't continue to the next step until you see `Snapshotting finished` for both `title_ratings` and `title_basics`:

        ``` sh
        docker logs readyset | grep 'Snapshotting finished'
        ```

        ``` {.text .no-copy}
        2022-12-13T16:03:11.155418Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=1246402
        2022-12-13T16:05:07.837214Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "quickstart-postgres"}) rows_replicated=5159701
        ```

## Step 4. Cache queries

With snapshotting finished, ReadySet is ready for caching, so in this step, you'll run some queries, check if ReadySet supports them, and then cache them.   

1. Get back into the `psql` container and connect it to ReadySet:

    ``` sh
    docker exec -it psql bash
    ```

    ``` sh
    PGPASSWORD=readyset psql \
    --host=readyset \
    --port=5433 \
    --username=postgres \
    --dbname=imdb
    ```

1. Run a query that joins results from `title_ratings` and `title_basics` to count how many titles released in 2000 have an average rating higher than 5:

    ``` sql
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    ``` {.text .no-copy}
      count
     -------
      14144
     (1 row)
    ```

1. Because the query is not yet cached, ReadySet proxied it to the upstream database. Use ReadySet's custom [`SHOW PROXIED QUERIES`](cache-queries.md#identify-queries-to-cache) command to check if ReadySet can cache the query:

    ``` sql
    SHOW PROXIED QUERIES;
    ```

    ``` {.text .no-copy}
          query id      |                                                                                            proxied query                                                                                             | readyset supported
    --------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------
     q_df958c381703f5d4 | SELECT count(*) FROM `title_ratings` JOIN `title_basics` ON (`title_ratings`.`tconst` = `title_basics`.`tconst`) WHERE ((`title_basics`.`startyear` = $1) AND (`title_ratings`.`averagerating` > 5)) | yes
    (1 row)
    ```

    You should see `yes` under `readyset supported`. If the value is `pending`, check again until you see `yes` or `no`.

    !!! tip

        To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../reference/sql-support.md#query-caching).

1. Cache the query in ReadySet:

    ``` sql
    CREATE CACHE FROM -- (1)
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    1.   To cache a query, you can provide either the full `SELECT` (as shown here) or the query ID listed in the `SHOW PROXIED QUERIES` output.

    !!! note

        Caching will take a few minutes, as it constructs the initial dataflow graph for the query and adds indexes to the relevant ReadySet table snapshots, as necessary. The `CREATE CACHE` command will return once this is complete.

1. Run a second query, this time joining results from your two tables to get the title and average rating of the 10 top-rated movies from 1950:

    ``` sql
    SELECT title_basics.originaltitle, title_ratings.averagerating
    FROM title_basics
    JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
    WHERE title_basics.startyear = 1950 AND title_basics.titletype = 'movie'
    ORDER BY title_ratings.averagerating DESC
    LIMIT 10;
    ```

    ``` {.text .no-copy}
              originaltitle              | averagerating
    -------------------------------------+---------------
    Le mariage de Mademoiselle Beulemans |           9.0
    Es kommt ein Tag                     |           8.7
    Nili                                 |           8.7
    Sudhar Prem                          |           8.7
    Pyar                                 |           8.6
    Jiruba Tetsu                         |           8.5
    Meena Bazaar                         |           8.5
    Pardes                               |           8.4
    Showkar                              |           8.4
    Siete muertes a plazo fijo           |           8.4
    (10 rows)
    ```

1. Use the [`SHOW PROXIED QUERIES`](cache-queries.md#identify-queries-to-cache) command to check if ReadySet can cache the query:

    ``` sql
    SHOW PROXIED QUERIES;
    ```

    ``` {.text .no-copy}
          query id      |                                                                                                                                             proxied query                                                                                                                                             | readyset supported
    --------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------
     q_21bee9ced453311c | SELECT `title_basics`.`originaltitle`, `title_ratings`.`averagerating` FROM `title_basics` JOIN `title_ratings` ON (`title_basics`.`tconst` = `title_ratings`.`tconst`) WHERE ((`title_basics`.`startyear` = $1) AND (`title_basics`.`titletype` = $2)) ORDER BY `title_ratings`.`averagerating` DESC | yes
    (1 row)
    ```

    You should see `yes` under `readyset supported`. If the value is `pending`, check again until you see `yes` or `no`.

1. Cache the query in ReadySet:

    ``` sql
    CREATE CACHE FROM
    SELECT title_basics.originaltitle, title_ratings.averagerating
    FROM title_basics
    JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
    WHERE title_basics.startyear = 1950 AND title_basics.titletype = 'movie'
    ORDER BY title_ratings.averagerating DESC
    LIMIT 10;
    ```

    !!! note

        Again, caching will take a few minutes, as it constructs the initial dataflow graph for the query and adds indexes to the relevant ReadySet table snapshots, as necessary. The `CREATE CACHE` command will return once this is complete.

1. Use ReadySet's custom [`SHOW CACHES`](cache-queries.md#cache-queries_1) command to verify that caches have been created for your two queries:

    ``` sql
    SHOW CACHES;
    ```

    ``` {.text .no-copy}
            name         |                                                                                                                                                                                         query                                                                                                                                                                                          | fallback behavior
    ----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------
    `q_21bee9ced453311c` | SELECT `public`.`title_basics`.`originaltitle`, `public`.`title_ratings`.`averagerating` FROM `public`.`title_basics` JOIN `public`.`title_ratings` ON (`public`.`title_basics`.`tconst` = `public`.`title_ratings`.`tconst`) WHERE ((`public`.`title_basics`.`startyear` = $1) AND (`public`.`title_basics`.`titletype` = $2)) ORDER BY `public`.`title_ratings`.`averagerating` DESC | fallback allowed
    `q_df958c381703f5d4` | SELECT count(coalesce(`public`.`title_ratings`.`tconst`, '<anonymized>')) FROM `public`.`title_ratings` JOIN `public`.`title_basics` ON (`public`.`title_ratings`.`tconst` = `public`.`title_basics`.`tconst`) WHERE ((`public`.`title_basics`.`startyear` = $1) AND (`public`.`title_ratings`.`averagerating` > '<anonymized>'))                                                      | fallback allowed
    (2 rows)        
    ```

1. Exit the `psql` shell and container:

    ``` sql
    \q
    ```

    ``` sh
    exit
    ```

## Step 5. Check latencies

Now you'll use a simple Python application to run your queries against both the database and ReadySet and compare how fast results are returned.

1. Create a fourth container for running the Python application:

    ``` sh
    docker run -dit \
    --name=app \
    --network=readyset-net \
    python:3.8-slim-buster \
    bash
    ```

1. Get into the container and install some dependencies for running the app:

    ``` sh
    docker exec -it app bash
    ```

    ``` sh
    apt-get update \
    && apt-get -y install libpq-dev gcc curl \
    && pip3 install psycopg2 numpy
    ```

1. Download the Python app:

    ``` sh
    curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-app.py
    ```

    The Python app runs a specified query 20 times and prints the latency of each iteration as well as the query latency distributions (50th, 90th, 95th, 99th, and 100th percentiles). To check the code, run:

    ``` sh
    cat quickstart-app.py
    ```

1. Run the first `JOIN` query against the database:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@postgres:5432/imdb?sslmode=disable" \
    --query="SELECT count(*) FROM title_ratings JOIN title_basics ON title_ratings.tconst = title_basics.tconst WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;"
    ```

    ``` text hl_lines="10"
    Result:
    ['count']
    ['14144']


    Query latencies (in milliseconds):
    ['261.31', '248.57', '239.23', '241.15', '239.70', '239.73', '240.10', '238.87', '239.38', '240.05', '239.80', '239.15', '238.33', '242.48', '246.25', '247.40', '239.31', '244.89', '239.60', '240.85']

    Latency percentiles (in milliseconds):
     p50: 239.92
     p90: 247.51
     p95: 249.21
     p99: 258.89
    p100: 261.31
    ```

    Note the latencies when results are returned from the database.

1. Run the same `JOIN` again, but this time against ReadySet:

    !!! tip

        Changing your connection string is the only change you make to your application. In this case, you're just changing the host and port from `postgres:5432` to `readyset:5433`.

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@readyset:5433/imdb?sslmode=disable" \
    --query="SELECT count(*) FROM title_ratings JOIN title_basics ON title_ratings.tconst = title_basics.tconst WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;"
    ```

    ``` text hl_lines="9"
    Result:
    ['count(coalesce(`public`.`title_ratings`.`tconst`, 0))']
    ['14144']

    Query latencies (in milliseconds):
    ['8.07', '0.71', '0.47', '0.34', '0.43', '0.38', '0.40', '0.41', '0.32', '0.41', '0.31', '0.37', '0.34', '0.46', '0.29', '0.31', '0.37', '0.28', '0.33', '0.33']

    Latency percentiles (in milliseconds):
     p50: 0.37
     p90: 0.49
     p95: 1.07
     p99: 6.67
    p100: 8.07
    ```

    As you can see, ReadySet returns results much faster. In the example here, the p50 latency went from 239.92ms to 0.37ms.

1. Now run the second `JOIN` query against the database:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@postgres:5432/imdb?sslmode=disable" \
    --query="SELECT title_basics.originaltitle, title_ratings.averagerating FROM title_basics JOIN title_ratings ON title_basics.tconst = title_ratings.tconst WHERE title_basics.startyear = 1950 AND title_basics.titletype = 'movie' ORDER BY title_ratings.averagerating DESC LIMIT 10;"
    ```

    ``` text hl_lines="19"
    Result:
    ['originaltitle', 'averagerating']
    ['Le mariage de Mademoiselle Beulemans', '9.0']
    ['Sudhar Prem', '8.7']
    ['Es kommt ein Tag', '8.7']
    ['Nili', '8.7']
    ['Pyar', '8.6']
    ['Meena Bazaar', '8.5']
    ['Jiruba Tetsu', '8.5']
    ['Vidyasagar', '8.4']
    ['Siete muertes a plazo fijo', '8.4']
    ['Tathapi', '8.4']


    Query latencies (in milliseconds):
    ['195.04', '179.04', '172.67', '170.25', '170.90', '175.98', '189.44', '186.62', '179.05', '179.87', '174.51', '176.44', '172.64', '172.13', '171.89', '170.64', '172.58', '172.00', '170.88', '171.12']

    Latency percentiles (in milliseconds):
     p50: 172.65
     p90: 186.90
     p95: 189.72
     p99: 193.98
    p100: 195.04
    ```

    Note the latencies when results are returned from the database.

1. Run the same `JOIN` again, but this time against ReadySet:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@readyset:5433/imdb?sslmode=disable" \
    --query="SELECT title_basics.originaltitle, title_ratings.averagerating FROM title_basics JOIN title_ratings ON title_basics.tconst = title_ratings.tconst WHERE title_basics.startyear = 1950 AND title_basics.titletype = 'movie' ORDER BY title_ratings.averagerating DESC LIMIT 10;"
    ```

    ``` text hl_lines="18"
    Result:
    ['originaltitle', 'averagerating']
    ['Le mariage de Mademoiselle Beulemans', '9.0']
    ['Es kommt ein Tag', '8.7']
    ['Nili', '8.7']
    ['Sudhar Prem', '8.7']
    ['Pyar', '8.6']
    ['Jiruba Tetsu', '8.5']
    ['Meena Bazaar', '8.5']
    ['Pardes', '8.4']
    ['Showkar', '8.4']
    ['Siete muertes a plazo fijo', '8.4']

    Query latencies (in milliseconds):
    ['9.30', '0.72', '0.52', '0.41', '0.46', '0.39', '0.43', '0.38', '0.43', '0.41', '0.38', '0.37', '0.37', '0.38', '0.34', '0.35', '0.40', '0.34', '0.40', '0.40']

    Latency percentiles (in milliseconds):
     p50: 0.40
     p90: 0.54
     p95: 1.15
     p99: 7.67
    p100: 9.30
    ```

    Again, ReadySet returns results much faster. In this case, p50 latency went from 172.65 ms to 0.40 ms.

1. Exit the `app` container:

    ``` sh
    exit
    ```

## Step 6. Cause a cache refresh

One of ReadySet's most important features is its ability to keep your cache up-to-date as writes are applied to the upstream database. In this step, you'll see this in action.

1. Get back into the `psql` container:

    ``` sh
    docker exec -it psql bash
    ```

1. Insert new rows that will change the count returned by your first `JOIN` query:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb \
    -c "INSERT INTO title_basics (tconst, titletype, primarytitle, originaltitle, isadult, startyear, runtimeminutes, genres)
          VALUES ('tt9999998', 'movie', 'The ReadySet movie', 'The ReadySet movie', false, 2000, 0, 'Adventure');
        INSERT INTO title_ratings (tconst, averagerating, numvotes)
          VALUES ('tt9999998', 10, 1000000);"
    ```

1. Exit the `psql` container:

    ``` sh
    exit
    ```

1. Get back into the `app` container:

    ``` sh
    docker exec -it app bash
    ```

1. Run the `JOIN` against ReadySet again:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@readyset:5433/imdb?sslmode=disable" \
    --query="SELECT count(*) FROM title_ratings JOIN title_basics ON title_ratings.tconst = title_basics.tconst WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;"
    ```

    ``` text hl_lines="3"
    Result:
    ['count(coalesce(`public`.`title_ratings`.`tconst`, 0))']
    ['14145']

    Query latencies (in milliseconds):
    ['8.64', '0.69', '0.64', '0.49', '0.59', '0.46', '0.32', '0.32', '0.35', '0.38', '0.31', '0.33', '0.32', '0.30', '0.38', '0.34', '0.34', '0.33', '0.30', '0.33']

    Latency percentiles (in milliseconds):
     p50: 0.34
     p90: 0.64
     p95: 1.09
     p99: 7.13
    p100: 8.64
    ```

    !!! success

        Previously, the count was 14144. Now, the count is 14145, and the query latencies are virtually unchanged. This shows how ReadySet automatically updates your cache, using the database's replication stream, with no action needed on your part to keep the database and cache in sync.

1. Exit the `app` container:

    ``` sh
    exit
    ```

## Step 7. Test more queries

Before tearing down your deployment, feel free to test more queries to see if they're supported by ReadySet and, if so, to see how much of a performance boost you get when the queries are cached.

You can find all of the commands earlier in the tutorial, but here they are again for convenience.

**To experiment with the dataset:**

``` sh
docker exec -it psql bash
```

``` sh
PGPASSWORD=readyset psql \
--host=readyset \
--port=5433 \
--username=postgres \
--dbname=imdb
```

**To check whether ReadySet supports a query:**

In the `psql` shell, after running the query, run `SHOW PROXIED QUERIES` and check the `readyset supported` value.

- If the value is `pending`, check again until you see `yes` or `no`.
- If the value is `yes`, ReadySet can cache the query.
- If the value is `no`, ReadySet cannot cache the query due to missing support for SQL features in the query. Check the [SQL Support](../reference/sql-support.md#query-caching) page for insights, and if the unsupported features are important to your use case, [submit a feature request](https://github.com/readysettech/readyset/issues/new/choose).

**To cache a query in ReadySet:**

In the `psql` shell, run `CREATE CACHE FROM <query text or query ID>`.

**To check how fast results are returned by Postgres:**

``` sh
docker exec -it app bash
```

``` sh
python3 quickstart-app.py \
--url="postgresql://postgres:readyset@postgres:5432/imdb?sslmode=disable" \
--query="<query text>"
```

**To check how fast results are returned by ReadySet:**

``` sh
docker exec -it app bash
```

``` sh
python3 quickstart-app.py \
--url="postgresql://postgres:readyset@readyset:5433/imdb?sslmode=disable" \
--query="<query text>"
```

## Step 8. Tear down

When you are done testing, use the following commands to stop and remove the resources used in this tutorial:

``` sh
docker rm -f readyset postgres psql app \
&& docker volume rm readyset \
&& docker network rm readyset-net
```

## Next steps

- [Connect an app](connect-an-app.md)

- [Review query support](../reference/sql-support.md)

- [Learn how ReadySet works under the hood](../concepts/overview.md)

- [Deploy with ReadySet Cloud](deploy-readyset-cloud.md)
