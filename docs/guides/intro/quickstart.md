# Quickstart

The quickstart sets up a ReadySet instance and a sample database on your local machine using Docker.

!!! attention

    Before starting, make sure you have Docker Engine version >= 19.03.0​ and Docker Compose V2 OR Docker Desktop >= 4.1.0 and the MySQL or Postgres client installed.

=== "Postgres"

    <font size="4">1. Download and run the ReadySet Docker Compose file</font>

    ```
    curl -o compose.yml "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/compose.postgres.yml" && docker compose pull && docker compose up -d
    ```


    <font size="4">2. Import sample data</font>

    ```
    curl -s "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/imdb-postgres.sql" | psql 'postgresql://postgres:readyset@127.0.0.1:5433/testdb'
    ```

    !!! warning

        Data loading will be slow on Macs with Apple Silicon.


    <font size="4">3. Connect and explore the dataset</font>

    Connect to ReadySet.

    ```
    psql 'postgresql://postgres:readyset@127.0.0.1:5433/testdb'
    ```

    Enable query timing.

    ```
    \timing
    ```

    Run a sample query.

    Note that since we have not created a cache, this query is served by Postgres.

    Query:
    ```
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Results:
    ```{.text .no-copy}
     count
    -------
      2418
    (1 row)

    Time: 154.980 ms
    ```


    <font size="4">4. Cache a query!</font>

    Using the `CREATE CACHE FROM` SQL extension, cache the query in ReadySet.

    ```
    CREATE CACHE FROM SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Validate that creating the cache succeeded by running the query again.  This time, it is served by ReadySet.

    Query:
    ```
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Results:
    ```{.text .no-copy}
     count(*)
    ----------
         2418
    (1 row)

    Time: 2.073 ms
    ```


    <font size="4">5. Explore Grafana</font>

    Navigate to localhost:4000 to view query latency metrics for ReadySet and Postgres.

    ![Grafana](../../assets/explore-grafana-postgres.png)


    <font size="4">6. Try more queries!</font>

    Explore the dataset and test ReadySet's performance with additional queries.

    View currently cached queries:
    ```
    SHOW CACHES;
    ```

    View proxied queries:
    ```
    SHOW PROXIED QUERIES;
    ```

    Remove a cache:
    ```
    DROP CACHE <cache id>;
    ```


=== "MySQL"

    <font size="4">1. Download and run the ReadySet Docker Compose file</font>

    ```
    curl -o compose.yml "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/compose.mysql.yml" && docker compose up -d
    ```


    <font size="4">2. Import sample data</font>

    ```
    curl -s "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/imdb-mysql.sql" | mysql -h127.0.0.1 -uroot -P3307 testdb -preadyset
    ```

    !!! warning

        Data loading will be slow on Macs with Apple Silicon.


    <font size="4">3. Connect and explore the dataset</font>

    Connect to ReadySet.

    ```
    mysql -h127.0.0.1 -uroot -P3307 testdb -preadyset
    ```

    Enable query timing.

    ```
    set profiling=1;
    ```

    Run a sample query.

    Note that since we have not created a cache, this query is served by MySQL.

    Query:
    ```
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Results:
    ```{.text .no-copy}
    +----------+
    | count(*) |
    +----------+
    |     2418 |
    +----------+
    1 row in set (0.69 sec)
    ```


    <font size="4">4. Cache a query!</font>

    Using the `CREATE CACHE FROM` SQL extension, cache the query in ReadySet.

    ```
    CREATE CACHE FROM SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Validate that creating the cache succeeded by running the query again.  This time, it is served by ReadySet.

    Query:
    ```
    SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;

    ```

    Results:
    ```{.text .no-copy}
    +----------+
    | count(*) |
    +----------+
    |     2418 |
    +----------+
    1 row in set (0.03 sec)
    ```


    <font size="4">5. Explore Grafana</font>

    Navigate to localhost:4000 to view query latency metrics for ReadySet and Postgres.

    ![Grafana](../../assets/explore-grafana-mysql.png)


    <font size="4">6. Try more queries!</font>

    Explore the dataset and test ReadySet's performance with additional queries.

    View currently cached queries:
    ```
    SHOW CACHES;
    ```

    View proxied queries:
    ```
    SHOW PROXIED QUERIES;
    ```

    Remove a cache:
    ```
    DROP CACHE <cache id>;
    ```
