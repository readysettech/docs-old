# Quickstart with ReadySet

This page shows you how to test ReadySet on your local machine using Docker.

You'll start a Postgres database, load sample data into it, connect ReadySet, cache some queries, and test how fast ReadySet returns results compared to Postgres. You'll then write to the database and see how ReadySet keeps your cache up-to-date automatically, with no changes to your application code.

## Before you begin

Make sure you have [Docker](https://docs.docker.com/engine/install/) installed and running.

## Step 1. Start the database

ReadySet sits between your database and application, so in this step, you'll start up a local instance of Postgres and load two sample tables from the [IMDb dataset](https://www.imdb.com/interfaces/).

1. Since you'll be running multiple Docker containers on a single host, create a bridge network for the containers to share:

    ``` sh
    docker network create -d bridge readyset-net
    ```

2. Create a new container and start Postgres inside it:

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

2. Take a moment to understand the flags you used:

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
    `-c` |  Turns on Postgres [logical replication](https://www.postgresql.org/docs/current/logical-replication.html). Once ReadySet has taken an initial snapshot of the database, it uses the logical replication stream to keep its snapshot and caches up-to-date as the database changes. You'll see this in action in [Step 5](#step-5-cause-a-cache-refresh).   

3. Create a second container for downloading sample data and running the `psql` client:

    ``` sh
    docker run -dit \
    --name=psql \
    --network=readyset-net \
    postgres:14 \
    bash
    ```

4. Get into the container and install some dependencies for downloading the sample data:

    ``` sh
    docker exec -it psql bash
    ```

    ``` sh
    apt-get update \
    && apt-get -y install curl unzip
    ```

5. Download CSV files containing data for these tables from the [IMDb dataset](https://www.imdb.com/interfaces/):

    ``` sh
    curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart_sample_data.zip \
    && unzip quickstart_sample_data.zip
    ```

6. Use the `psql` client to create the schema for 2 tables, `title_basics` and `title_ratings`:

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

7. Load the data into each table:

    !!! note

        These commands will take a few minutes, as they load 5159701 rows into `title_basics` and 1246402 rows into `title_ratings`.

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

8. Open the `psql` shell and get a sense of the data in each table:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=postgres \
    --port=5432 \
    --username=postgres \
    --dbname=imdb
    ```

    ``` sql
    SELECT * FROM title_basics WHERE tconst = 'tt0093779';
    SELECT * FROM title_ratings WHERE tconst = 'tt0093779';
    ```

    ``` {.text .no-copy}
      tconst   | titletype |    primarytitle    |   originaltitle    | isadult | startyear | endyear | runtimeminutes |          genres
    -----------+-----------+--------------------+--------------------+---------+-----------+---------+----------------+--------------------------
     tt0093779 | movie     | The Princess Bride | The Princess Bride | f       |      1987 |         |             98 | Adventure,Family,Fantasy
    (1 row)

      tconst   | averagerating | numvotes
    -----------+---------------+----------
     tt0093779 |           8.0 |   427192
    (1 row)
    ```

9. Exit the `psql` shell and container:

    ``` sql
    \q
    ```

    ``` sh
    exit
    ```

## Step 2. Connect ReadySet

Now that you have a live database with sample data, you'll connect ReadySet to the database and watch it take a snapshot of your tables. This snapshot will be the basis for ReadySet to cache query results, and ReadySet will keep its snapshot and cache up-to-date automatically by listening to the database's replication stream.

1. Create a third container and start ReadySet inside it, connecting ReadySet to your Postgres database via the connection string in `--upstream-db-url`:

    ``` sh
    docker run -d \
    --name=readyset \
    --publish=5433:5433 \
    --network=readyset-net \
    --platform=linux/amd64 \
    --volume='readyset:/state' \
    -e ENGINE=psql \
    -e DEPLOYMENT_ENV=quickstart_docker \
    public.ecr.aws/readyset/readyset-adapter:latest \
    --standalone \
    --deployment='quickstart-postgres' \
    --upstream-db-url=postgresql://postgres:readyset@postgres:5432/imdb \
    --address=0.0.0.0:5433 \
    --username='postgres' \
    --password='readyset' \
    --query-caching='explicit' \
    --db-dir='/state'
    ```

2. This `docker run` command is similar to the one you used to start Postgres. However, the environment variable set in the container and the flags following the `readyset-psql` image are specific to ReadySet. Take a moment to understand them:

    Flag | Details
    -----|--------
    `-e` | The `readyset-adapter` image works with both Postgres and MySQL. You set the `ENGINE` environment variable to specify which one you're using. For this tutorial, you also set an environment variable to allow ReadySet to categorize your deployment as a quickstart experience in anonymous [telemetry](../reference/telemetry.md) data.
    `--standalone` | <p>For [production deployments](deploy-readyset-kubernetes.md), you run the ReadySet Server and Adapter as separate processes. For local testing, however, you can run the Server and Adapter as a single process by passing the `--standalone` flag to the ReadySet Adapter command.</p>
    `--deployment` | A unique identifier for the ReadySet deployment.
    `--upstream-db-url` | <p>The URL for connecting ReadySet to Postgres. This connection URL includes the username and password for ReadySet to authenticate with as well as the database to replicate.</p><div class="admonition tip"><p class="admonition-title">Tip</p><p>By default, ReadySet replicates all tables in all schemas of the specified Postgres database. For this tutorial, that's fine. However, in future deployments, if the queries you want to cache access only a specific schema or specific tables in a schema, or if some tables can't be replicated by ReadySet because they contain [data types](../reference/sql-support/#data-types) that ReadySet does not support, you can narrow the scope of replication by passing `--replication-tables=<schema.table>,<schema.table>`.</p>
    `--address` | The IP and port that ReadySet listens on. For this tutorial, ReadySet is running locally on a different port than Postgres, so connecting `psql` to ReadySet is just a matter of changing the port from `5432` to `5433`.</p>       
    `--username`<br>`--password`| The username and password for connecting clients to ReadySet. For this tutorial, you're using the same username and password for both Postgres and ReadySet.
    `--query-caching` | <p>The query caching mode for ReadySet.</p><p>For this tutorial, you've set this to `explicit`, which means you must run a specific command to have ReadySet cache a query (covered in [Step 4](#step-4-cache-queries)). The other options are `inrequestpath` and `async`. `inrequestpath` caches [supported queries](../reference/sql-support/#query-caching) automatically but blocks queries from returning results until the cache is ready. `async` also caches supported queries automatically but proxies queries to the upstream database until the cache is ready. For most deployments, the `explicit` option is recommended, as it gives you the most flexibility and control.</p>
    `--db-dir` | The directory in which to store replicated table data. For this tutorial, you're using a Docker volume that will persist after the container is stopped.

3. Watch as ReadySet takes a snapshot of your tables:

    !!! note

        Snapshotting will take a few minutes. For each table, you'll see the progress and the estimated time remaining in the log messages (e.g., `progress=84.13% estimate=00:00:23`).

    ``` sh
    docker logs readyset | grep 'Replicating table'
    ```

    ``` {.text .no-copy}
    2022-11-11T19:37:49.467850Z  INFO Replicating table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Replicating table
    2022-11-11T19:37:49.621510Z  INFO Replicating table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting started rows=1246402
    2022-11-11T19:38:10.379432Z  INFO Replicating table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished rows_replicated=1246402
    2022-11-11T19:38:10.380743Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Replicating table
    2022-11-11T19:38:10.806728Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting started rows=5159701
    2022-11-11T19:38:41.816038Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress rows_replicated=1085440 progress=21.04% estimate=00:01:56
    2022-11-11T19:39:12.831545Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress rows_replicated=2170880 progress=42.07% estimate=00:01:25
    2022-11-11T19:39:43.869316Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress rows_replicated=3259392 progress=63.17% estimate=00:00:54
    2022-11-11T19:40:14.878916Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress rows_replicated=4340736 progress=84.13% estimate=00:00:23
    2022-11-11T19:40:38.566688Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished rows_replicated=5159701
    ```

    Don't continue to the next step until you see `Snapshotting finished` for both `title_ratings` and `title_basics`:

    ``` sh
    docker logs readyset | grep 'Snapshotting finished'
    ```

    ``` {.text .no-copy}
    2022-11-11T19:38:10.379432Z  INFO Replicating table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished rows_replicated=1246402
    2022-11-11T19:40:38.566688Z  INFO Replicating table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished rows_replicated=5159701
    ```

## Step 3. Cache queries

With snapshotting finished, ReadySet is ready for caching, so in this step, you'll run some queries, check if ReadySet supports them, and then cache them.   

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

2. Run a query that joins results from `title_ratings` and `title_basics` to count how many titles released in 2000 have an average rating higher than 5:

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

3. Because the query is not yet cached, ReadySet proxied it to the upstream database. Use ReadySet's custom [`SHOW PROXIED QUERIES`](../cache-queries/#identify-queries-to-cache) command to check if ReadySet can cache the query:

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

        To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../reference/sql-support/#query-caching).

4. Cache the query in ReadySet:

    ``` sql
    CREATE CACHE FROM -- (1)
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    1.   To cache a query, you can provide either the full `SELECT` (as shown here) or the query ID listed in the `SHOW PROXIED QUERIES` output.

    !!! note

        Caching will take a few minutes, as it constructs the initial dataflow graph for the query and adds indexes to the relevant ReadySet table snapshots, as necessary. The `CREATE CACHE` command will return once this is complete.

5. Run a second query, this time joining results from your two tables to get the title and average rating of the 10 top-rated movies from 1950:

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

6. Use the [`SHOW PROXIED QUERIES`](../cache-queries/#identify-queries-to-cache) command to check if ReadySet can cache the query:

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

7. Cache the query in ReadySet:

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

8. Use ReadySet's custom [`SHOW CACHES`](../cache-queries/#cache-queries_1) command to verify that caches have been created for your two queries:

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

9. Exit the `psql` shell and container:

    ``` sql
    \q
    ```

    ``` sh
    exit
    ```

## Step 4. Check latencies

Now you'll use a simple Python application to run your queries against both the database and ReadySet and compare how fast results are returned.

1. Create a fourth container for running the Python application:

    ``` sh
    docker run -dit \
    --name=app \
    --network=readyset-net \
    python:3.8-slim-buster \
    bash
    ```

2. Get into the container and install some dependencies for running the app:

    ``` sh
    docker exec -it app bash
    ```

    ``` sh
    apt-get update \
    && apt-get -y install libpq-dev gcc curl \
    && pip3 install psycopg2
    ```

3. Download the Python app:

    ``` sh
    curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-app.py
    ```

4. Run the first `JOIN` query against the database:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@postgres:5432/imdb?sslmode=disable" \
    --query="SELECT count(*) FROM title_ratings JOIN title_basics ON title_ratings.tconst = title_basics.tconst WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;"
    ```

    ``` text hl_lines="9"
    Result:
    ['count']
    ['14144']

    Query latencies (in milliseconds):
    [566.7273998260498, 254.38809394836426, 237.54477500915527, 238.02709579467773, 236.1123561859131, 234.16709899902344, 234.50851440429688, 235.5213165283203, 236.62209510803223, 233.14189910888672, 236.04488372802734, 236.33122444152832, 234.19809341430664, 236.9060516357422, 236.9368076324463, 263.0195617675781, 246.96660041809082, 260.5435848236084, 258.90254974365234, 245.91660499572754]

    Median query latency (in milliseconds):
    236.92142963409424
    ```

    The Python app runs the query 20 times and prints the latency of each iteration as well as the median query latency. Note the median latency when results are returned from the database.

5. Run the same `JOIN` again, but this time against ReadySet:

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
    [147.66454696655273, 1.4758110046386719, 0.3712177276611328, 0.29015541076660156, 0.27489662170410156, 0.2846717834472656, 0.27489662170410156, 0.26798248291015625, 0.26535987854003906, 0.2770423889160156, 0.26798248291015625, 0.26035308837890625, 0.24843215942382812, 0.2856254577636719, 0.34546852111816406, 0.3268718719482422, 0.3361701965332031, 0.28586387634277344, 0.2803802490234375, 0.28586387634277344]

    Median query latency (in milliseconds):
    0.28514862060546875
    ```

    As you can see, ReadySet returns results much faster. In the example here, latency went from 236.9ms to 0.3ms.

6. Now run the second `JOIN` query against the database:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@postgres:5432/imdb?sslmode=disable" \
    --query="SELECT title_basics.originaltitle, title_ratings.averagerating FROM title_basics JOIN title_ratings ON title_basics.tconst = title_ratings.tconst WHERE title_basics.startyear = 1950 AND title_basics.titletype = 'movie' ORDER BY title_ratings.averagerating DESC LIMIT 10;"
    ```

    ``` text hl_lines="18"
    Result:
    ['originaltitle', 'averagerating']
    ['Le mariage de Mademoiselle Beulemans', '9.0']
    ['Sudhar Prem', '8.7']
    ['Es kommt ein Tag', '8.7']
    ['Nili', '8.7']
    ['Pyar', '8.6']
    ['Meena Bazaar', '8.5']
    ['Jiruba Tetsu', '8.5']
    ['Siete muertes a plazo fijo', '8.4']
    ['Showkar', '8.4']
    ['Tathapi', '8.4']

    Query latencies (in milliseconds):
    [502.3610591888428, 172.79624938964844, 170.99690437316895, 170.18723487854004, 169.0659523010254, 170.57228088378906, 186.63430213928223, 179.0142059326172, 176.57208442687988, 186.58065795898438, 183.3055019378662, 178.94220352172852, 174.9889850616455, 176.33867263793945, 180.10997772216797, 174.98064041137695, 177.19364166259766, 171.53334617614746, 171.39816284179688, 171.39506340026855]

    Median query latency (in milliseconds):
    175.66382884979248
    ```

    Note the median latency when results are returned from the database.

7. Run the same `JOIN` again, but this time against ReadySet:

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
    [187.32094764709473, 1.1928081512451172, 0.3998279571533203, 0.4241466522216797, 0.4048347473144531, 0.37598609924316406, 0.4181861877441406, 0.3223419189453125, 0.33545494079589844, 0.4162788391113281, 0.3523826599121094, 0.3304481506347656, 0.35858154296875, 0.2868175506591797, 0.400543212890625, 0.3719329833984375, 0.33402442932128906, 0.4017353057861328, 0.33020973205566406, 0.43320655822753906]

    Median query latency (in milliseconds):
    0.3879070281982422
    ```

    Again, ReadySet returns results much faster. In this case, latency went from 175.6ms to 0.4ms.

8. Exit the `app` container:

    ``` sh
    exit
    ```

## Step 5. Cause a cache refresh

One of ReadySet's most important features is its ability to keep your cache up-to-date as writes are applied to the upstream database. In this step, you'll see this in action.

1. Get back into the `psql` container:

    ``` sh
    docker exec -it psql bash
    ```

2. Insert new rows that will change the count returned by your first `JOIN` query:

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

3. Exit the `psql` container:

    ``` sh
    exit
    ```

4. Get back into the `app` container:

    ``` sh
    docker exec -it app bash
    ```

5. Run the `JOIN` against ReadySet again:

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
    [10.125160217285156, 0.7064342498779297, 0.40841102600097656, 0.3204345703125, 0.3342628479003906, 0.2732276916503906, 0.2651214599609375, 0.2586841583251953, 0.31447410583496094, 0.2951622009277344, 0.2849102020263672, 0.3254413604736328, 0.347137451171875, 0.30803680419921875, 0.3619194030761719, 0.3151893615722656, 0.3483295440673828, 0.39124488830566406, 0.3299713134765625, 0.3707408905029297]

    Median query latency (in milliseconds):
    0.32770633697509766
    ```

    !!! success

        Previously, the count was 14144. Now, the count is 14145, and the median query latency is virtually unchanged. This shows how ReadySet automatically updates your cache, using the database's replication stream, with no action needed on your part to keep the database and cache in sync.

6. Exit the `app` container:

    ``` sh
    exit
    ```

## Step 6. Test more queries

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
- If the value is `no`, ReadySet cannot cache the query due to missing support for SQL features in the query. Check the [SQL Support](../reference/sql-support/#query-caching) page for insights, and if the unsupported features are important to your use case, [submit a feature request](https://github.com/readysettech/readyset/issues/new/choose).

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

## Step 7. Tear down

When you are done testing, use the following commands to stop and remove the resources used in this tutorial:

``` sh
docker stop readyset postgres psql app
```

``` sh
docker rm readyset postgres psql app
```

``` sh
docker volume rm readyset
```

``` sh
docker network rm readyset-net
```
