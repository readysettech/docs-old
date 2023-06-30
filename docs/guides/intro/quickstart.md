# Quickstart

The quickstart sets up a ReadySet instance and a sample database on your local machine using Docker.

!!! warning

    Before starting, make sure you have Docker Engine version >= 19.03.0​ and Docker Compose V2 OR Docker Desktop >= 4.1.0 and the MySQL or Postgres client installed.

=== "Postgres"

    ### 1. Download and run the ReadySet Docker Compose file

    ```
    curl -o compose.yml "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/compose.postgres.yml" && docker compose up -d
    ```


    ### 2. Import sample data

    ```
    curl -s "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/imdb-postgres.sql" | psql 'postgresql://postgres:readyset@127.0.0.1:5433/testdb'
    ```

    !!! warning

        Data loading will be slow on Macs with Apple Silicon.


    ### 3. Connect and explore the dataset

    Connect to ReadySet and enable query timing.

    ```
    psql 'postgresql://postgres:readyset@127.0.0.1:5433/testdb'
    testdb=> \timing
    ```

    Run a sample query.
    
    Note that since we have not created a cache, this query is served by Postgres.

    ```
    testdb=> SELECT count(*) FROM title_ratings 
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst 
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    count
    -------
    4764
    (1 row)

    Time: 154.980 ms
    ```


    ### 4. Cache a query!

    Using the `CREATE CACHE FROM` SQL extension, cache the query in ReadySet.

    ```
    testdb=> CREATE CACHE FROM SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Validate that creating the cache succeeded by running the query again.  This time, it is served by ReadySet.

    ```
    testdb=> SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    count(coalesce(`public`.`title_ratings`.`tconst`, 0))
    -------------------------------------------------------
                                                    4756
    (1 row)

    Time: 2.073 ms
    ```


    ### 5. Explore Grafana

    Navigate to localhost:4000 to view query latency metrics for ReadySet and Postgres.

    ![Grafana](../../assets/explore-grafana-postgres.png)


    ### 6. Try more queries!

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

    ### 1. Download and run the ReadySet Docker Compose file

    ```
    curl -o compose.yml "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/compose.mysql.yml" && docker compose up -d
    ```


    ### 2. Import sample data

    ```
    curl -s "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/imdb-mysql.sql" | mysql -h127.0.0.1 -uroot -P3307 testdb -preadyset
    ```

    !!! warning

        Data loading will be slow on Macs with Apple Silicon.


    ### 3. Connect and explore the dataset

    Connect to ReadySet and enable query timing.

    ```
    mysql -h127.0.0.1 -uroot -P3307 testdb -preadyset
    mysql> set profiling=1;
    ```

    Run a sample query.
    
    Note that since we have not created a cache, this query is served by MySQL.

    ```
    mysql> SELECT count(*) FROM title_ratings 
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst 
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    +----------+
    | count(*) |
    +----------+
    |     2418 |
    +----------+
    1 row in set (0.69 sec)
    ```


    ### 4. Cache a query!

    Using the `CREATE CACHE FROM` SQL extension, cache the query in ReadySet.

    ```
    mysql> CREATE CACHE FROM SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    ```

    Validate that creating the cache succeeded by running the query again.  This time, it is served by ReadySet.

    ```
    mysql> SELECT count(*) FROM title_ratings
    JOIN title_basics ON title_ratings.tconst = title_basics.tconst
    WHERE title_basics.startyear = 2000 AND title_ratings.averagerating > 5;
    +-------------------------------------------------------+
    | count(coalesce(`testdb`.`title_ratings`.`tconst`, 0)) |
    +-------------------------------------------------------+
    |                                                  2418 |
    +-------------------------------------------------------+
    1 row in set (0.03 sec)
    ```


    ### 5. Explore Grafana

    Navigate to localhost:4000 to view query latency metrics for ReadySet and Postgres.

    ![Grafana](../../assets/explore-grafana-mysql.png)


    ### 6. Try more queries!

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
