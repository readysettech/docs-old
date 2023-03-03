# Quickstart with ReadySet

This tutorial shows you the quickest way to get started with ReadySet.

- First, you'll use Docker Compose to start Postgres, load some sample data, and connect ReadySet to the database.
- Next, you'll check on ReadySet's snapshotting process, cache some queries, and then run a simple Python app to compare how fast ReadySet returns results compared to Postgres.
- Finally, you'll write to the database and see how ReadySet keeps your cache up-to-date automatically, with no changes to your application code.

!!! tip

    To run through this quickstart in your browser, go the [ReadySet Playground](playground.md).

## Before you begin

- Install and start [Docker Compose](https://docs.docker.com/engine/install/) for your OS.
- Install the [`psql` shell](https://www.postgresql.org/docs/current/app-psql.html).

## Step 1. Start ReadySet

In this step, you'll use Docker Compose to start Postgres, load some sample data, and connect ReadySet to the database.

1. Download the Docker Compose and sample data files:

    ``` sh
    curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/{docker-compose-postgres.yml,imdb-postgres.sql}"
    ```

1. Run Docker Compose:

    ``` sh
    docker-compose -f docker-compose-postgres.yml up -d
    ```

    Compose then does the following:

    - Starts Postgres in a container called `db` and imports two tables from the [IMDb dataset](https://www.imdb.com/interfaces/).
    - Starts ReadySet in a container called `cache`. For details about the CLI options used to start ReadySet, see the [CLI reference docs](../reference/cli/readyset.md).   
    - Creates a container called `app` for running a sample Python app against ReadySet.

## Step 2. Check snapshotting

As soon as ReadySet is connected to the database, it starts storing a snapshot of your database tables on disk. This snapshot will be the basis for ReadySet to cache query results, and ReadySet will keep its snapshot and cache up-to-date automatically by listening to the database's [replication stream](https://www.postgresql.org/docs/current/logical-replication.html). Queries can be cached in ReadySet only once all tables have finished the initial snapshotting process.

Snapshotting can take between a few minutes to several hours, depending on the size of your dataset. In this tutorial, snapshotting should take no more than a few minutes. Check the status of snapshotting, and make sure it's complete, before continuing to the next step.

1. Connect the `psql` shell to ReadySet, using the port that ReadySet is listening on, `5433`:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=127.0.0.1 \
    --port=5433 \
    --username=postgres \
    --dbname=imdb
    ```

1. Run ReadySet's custom [`SHOW READYSET TABLES`](check-snapshotting.md#check-overall-status) command to check the snapshotting status of tables in the database ReadySet is connected to:

    ``` sql
    SHOW READYSET TABLES;
    ```

    ``` {.text .no-copy}
            table            |   status
    -------------------------+------------
    `public`.`title_basics`  | Snapshotted
    `public`.`title_ratings` | Snapshotted
    (2 rows)
    ```

    There are 3 possible statuses:

    - **Snapshotting:** The initial snapshot of the table is in progress.
    - **Snapshotted:** The initial snapshot of the table is complete. ReadySet is replicating changes to the table via the database's replication stream.
    - **Not Replicated:** The table has not been snapshotted by ReadySet. This can be because ReadySet encountered an error (e.g., due to [unsupported data types](../reference/sql-support.md#data-types)) or the table has been intentionally excluded from snapshotting (via the [`--replication-tables`](../reference/cli/readyset.md#-replication-tables) option).

1. If you'd like to track snapshotting progress in greater detail, open a new terminal, and check the ReadySet logs:

    ``` sh
    docker logs readyset | grep 'Snapshotting table'
    ```

    ``` {.text .no-copy}
    2023-02-13T17:02:59.189523Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "docs_quickstart_postgres"})
    2023-02-13T17:02:59.240229Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "docs_quickstart_postgres"})
    2023-02-13T17:02:59.331648Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "docs_quickstart_postgres"}) rows=396793
    2023-02-13T17:02:59.341948Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "docs_quickstart_postgres"}) rows=201258
    2023-02-13T17:03:02.115769Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "docs_quickstart_postgres"}) rows_replicated=201258
    2023-02-13T17:03:09.837387Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "docs_quickstart_postgres"}) rows_replicated=396793
    ```

    Again, don't continue to the next step until you see `Snapshotting finished` for both `title_ratings` and `title_basics`:

    ``` sh
    docker logs readyset | grep 'Snapshotting finished'
    ```

    ``` {.text .no-copy}
    2023-02-13T17:03:02.115769Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "docs_quickstart_postgres"}) rows_replicated=201258
    2023-02-13T17:03:09.837387Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "docs_quickstart_postgres"}) rows_replicated=396793
    ```

## Step 3. Cache queries

With snapshotting finished, ReadySet is ready for caching, so in this step, you'll get to know the dataset, run some queries, check if ReadySet supports them, and then cache them.   

1. If necessary, reconnect the `psql` shell to ReadySet:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=127.0.0.1 \
    --port=5433 \
    --username=postgres \
    --dbname=imdb
    ```

1. The `imdb` database contains two modified tables from the [IMDb dataset](https://www.imdb.com/interfaces/), `title_basics` and `title_ratings`. Get a sense of the data in each table:

    ``` sql
    SELECT count(*) FROM title_basics;
    SELECT * FROM title_basics WHERE tconst = 'tt0093779';
    ```

    ``` {.text .no-copy}
      count
     --------
      396793
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
     --------
      201258
     (1 row)

       tconst   | averagerating | numvotes
     -----------+---------------+----------
      tt0093779 |           8.0 |   427192
     (1 row)    
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
       2418
     (1 row)
    ```

1. Because the query is not yet cached, ReadySet proxied it to the upstream database. Use ReadySet's custom [`SHOW PROXIED QUERIES`](cache-queries.md#check-query-support) command to check if ReadySet can cache the query:

    ``` sql
    SHOW PROXIED QUERIES;
    ```

    ``` {.text hl_lines="5"}
         query id      |                                                                                            proxied query                                                                                             | readyset supported
    -------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------
    q_2f1af226d10ee188 | SELECT * FROM `title_ratings` WHERE (`tconst` = $1)                                                                                                                                                  | yes
    q_19b5998c761fd61d | SELECT count(*) FROM `title_basics`                                                                                                                                                                  | yes
    q_5348e5187dbf1722 | SELECT count(*) FROM `title_ratings` JOIN `title_basics` ON (`title_ratings`.`tconst` = `title_basics`.`tconst`) WHERE ((`title_basics`.`startyear` = $1) AND (`title_ratings`.`averagerating` > 5)) | yes
    q_e31fbaf56a443b93 | SELECT count(*) FROM `title_ratings`                                                                                                                                                                 | yes
    q_e948c4c2f747b1a7 | SELECT * FROM `title_basics` WHERE (`tconst` = $1)                                                                                                                                                   | yes
    (5 rows)
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

    1. To cache a query, you can provide either the full `SELECT` (as shown here) or the query ID listed in the `SHOW PROXIED QUERIES` output.

    !!! note

        Caching will take a few moments, as it constructs the initial dataflow graph for the query and adds indexes to the relevant ReadySet table snapshots, as necessary. The `CREATE CACHE` command will return once this is complete.

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
                 originaltitle             | averagerating
      -------------------------------------+---------------
      Le mariage de Mademoiselle Beulemans |           9.0
      Es kommt ein Tag                     |           8.7
      Nili                                 |           8.7
      Sudhar Prem                          |           8.7
      Pyar                                 |           8.6
      Jiruba Tetsu                         |           8.5
      Meena Bazaar                         |           8.5
      Vidyasagar                           |           8.4
      Siete muertes a plazo fijo           |           8.4
      Tathapi                              |           8.4
      (10 rows)
    ```

1. Use the [`SHOW PROXIED QUERIES`](cache-queries.md#check-query-support) command to check if ReadySet can cache the query:

    ``` sql
    SHOW PROXIED QUERIES;
    ```

    ``` {.text hl_lines="3"}
         query id      |                                                                                                                                             proxied query                                                                                                                                             | readyset supported
    -------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------
    q_8dba9d9bee766310 | SELECT `title_basics`.`originaltitle`, `title_ratings`.`averagerating` FROM `title_basics` JOIN `title_ratings` ON (`title_basics`.`tconst` = `title_ratings`.`tconst`) WHERE ((`title_basics`.`startyear` = $1) AND (`title_basics`.`titletype` = $2)) ORDER BY `title_ratings`.`averagerating` DESC | yes
    q_2f1af226d10ee188 | SELECT * FROM `title_ratings` WHERE (`tconst` = $1)                                                                                                                                                                                                                                                   | yes
    q_19b5998c761fd61d | SELECT count(*) FROM `title_basics`                                                                                                                                                                                                                                                                   | yes
    q_e31fbaf56a443b93 | SELECT count(*) FROM `title_ratings`                                                                                                                                                                                                                                                                  | yes
    q_e948c4c2f747b1a7 | SELECT * FROM `title_basics` WHERE (`tconst` = $1)                                                                                                                                                                                                                                                    | yes
    (5 rows)
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

    Again, caching will take a few moments.

1. Use ReadySet's custom [`SHOW CACHES`](cache-queries.md#cache-queries_1) command to verify that caches have been created for your two queries:

    ``` sql
    SHOW CACHES;
    ```

    ``` {.text .no-copy}
        name         |                                                                                                                                                                                         query                                                                                                                                                                                          | fallback behavior
    ----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------
    `q_5348e5187dbf1722` | SELECT count(coalesce(`public`.`title_ratings`.`tconst`, '<anonymized>')) FROM `public`.`title_ratings` JOIN `public`.`title_basics` ON (`public`.`title_ratings`.`tconst` = `public`.`title_basics`.`tconst`) WHERE ((`public`.`title_basics`.`startyear` = $1) AND (`public`.`title_ratings`.`averagerating` > '<anonymized>'))                                                      | fallback allowed
    `q_8dba9d9bee766310` | SELECT `public`.`title_basics`.`originaltitle`, `public`.`title_ratings`.`averagerating` FROM `public`.`title_basics` JOIN `public`.`title_ratings` ON (`public`.`title_basics`.`tconst` = `public`.`title_ratings`.`tconst`) WHERE ((`public`.`title_basics`.`startyear` = $1) AND (`public`.`title_basics`.`titletype` = $2)) ORDER BY `public`.`title_ratings`.`averagerating` DESC | fallback allowed
    (2 rows)
    ```

1. Exit the `psql` shell:

    ``` sql
    \q
    ```

## Step 4. Run an app

Now you'll use a simple Python application to run your queries against both the database and ReadySet and compare how fast results are returned.

1. Get into the Python container created by the Docker Compose config and install some dependencies for running the app:

    ``` sh
    docker exec -it app bash
    ```

    ``` sh
    apt-get update \
    && apt-get -y install libpq-dev gcc curl \
    && pip3 install psycopg2 numpy urllib3 tabulate
    ```

1. Download the Python app:

    ``` sh
    curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-app.py
    ```

    The Python app runs a specified query 20 times and prints the latency of each iteration as well as the query latency distributions (50th, 90th, 95th, 99th, and 100th percentiles). Feel free to review the code:

    ``` sh
    cat quickstart-app.py
    ```

1. Run the first `JOIN` query against Postgres:

    ``` sh
    python3 quickstart-app.py \
    --url="postgresql://postgres:readyset@postgres:5432/imdb?sslmode=disable" \
    --query="SELECT count(*) FROM title_ratings JOIN title_basics ON title_ratings.tconst = title_basics.tconst WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;"
    ```

    ``` text hl_lines="9"
    Result:
    ['count']
    ['2418']

    Query latencies (in milliseconds):
    ['63.18', '34.35', '32.47', '31.56', '30.43', '30.23', '30.07', '30.31', '30.23', '30.17', '30.28', '30.56', '30.45', '30.42', '30.25', '30.15', '30.20', '30.08', '30.04', '31.69']

    Latency percentiles (in milliseconds):
     p50: 30.29
     p90: 32.66
     p95: 35.79
     p99: 57.70
    p100: 63.18
    ```

    Note the latencies when results are returned from the database. Also note that these latencies would be higher with a larger dataset.

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
    ['2418']

    Query latencies (in milliseconds):
    ['7.93', '1.09', '0.46', '0.37', '0.41', '0.45', '0.61', '0.38', '0.26', '0.24', '0.24', '0.31', '0.25', '0.25', '0.29', '0.23', '0.23', '0.23', '0.24', '0.22']

    Latency percentiles (in milliseconds):
     p50: 0.28
     p90: 0.66
     p95: 1.44
     p99: 6.63
    p100: 7.93
    ```

    As you can see, ReadySet returns results much faster. In the example here, the p50 latency went from 30.29ms to 0.28ms.

1. Now run the second `JOIN` query against Postgres:

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
    ['57.72', '30.14', '27.82', '27.71', '27.77', '27.49', '27.62', '27.56', '27.74', '27.69', '28.86', '29.06', '27.50', '27.69', '27.44', '27.54', '27.50', '27.42', '28.43', '27.52']

    Latency percentiles (in milliseconds):
     p50: 27.69
     p90: 29.17
     p95: 31.52
     p99: 52.48
    p100: 57.72
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
    ['9.24', '0.57', '0.41', '0.41', '0.36', '0.39', '0.36', '0.37', '0.36', '0.38', '0.35', '0.38', '0.33', '0.37', '0.36', '0.33', '0.35', '0.34', '0.32', '0.48']

    Latency percentiles (in milliseconds):
     p50: 0.37
     p90: 0.49
     p95: 1.00
     p99: 7.59
    p100: 9.24
    ```

    ReadySet returns results much faster. In this case, p50 latency went from 27.69 ms to 0.37 ms.

    !!! note

        It's important to note that latencies from the database would increase with a larger dataset, whereas latencies from ReadySet would stay mostly constant, as results are returned from memory.

1. Exit the `app` container:

    ``` sh
    exit
    ```

## Step 5. Cause a cache refresh

One of ReadySet's most important features is its ability to keep your cache up-to-date as writes are applied to the upstream database. In this step, you'll see this in action.

1. Use `psql` to insert new rows that will change the count returned by your first `JOIN` query:

    ``` sh
    PGPASSWORD=readyset psql \
    --host=127.0.0.1 \
    --port=5432 \
    --username=postgres \
    --dbname=imdb \
    -c "INSERT INTO title_basics (tconst, titletype, primarytitle, originaltitle, isadult, startyear, runtimeminutes, genres)
          VALUES ('tt9999998', 'movie', 'The ReadySet movie', 'The ReadySet movie', false, 2000, 0, 'Adventure');
        INSERT INTO title_ratings (tconst, averagerating, numvotes)
          VALUES ('tt9999998', 10, 1000000);"
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
    ['2419']

    Query latencies (in milliseconds):
    ['8.12', '0.52', '0.35', '0.35', '0.32', '0.29', '0.34', '0.30', '0.35', '0.60', '0.46', '0.42', '0.39', '0.41', '0.32', '0.33', '0.37', '0.33', '0.38', '0.32']

    Latency percentiles (in milliseconds):
     p50: 0.35
     p90: 0.53
     p95: 0.98
     p99: 6.69
    p100: 8.12
    ```

    !!! success

        Previously, the count was 2418. Now, the count is 2419, and the query latencies are virtually unchanged. This shows how ReadySet automatically updates your cache, using the database's replication stream, with no action needed on your part to keep the database and cache in sync.

1. Exit the `app` container:

    ``` sh
    exit
    ```

## Step 6. Clean up

When you are done testing, stop and remove the resources used in this tutorial:

``` sh
docker-compose -f docker-compose-postgres.yml down -v
```

## Next steps

- [Connect an app](connect-an-app.md)

- [Review query support](../reference/sql-support.md)

- [Learn how ReadySet works under the hood](../concepts/overview.md)

- [Deploy with ReadySet Cloud](deploy-readyset-cloud.md)

<script async defer data-website-id="d654121f-0f12-4e71-87fe-97ac9a08e93f" src="http://umami.jesse.readyset.cloud:3000/umami.js"></script>