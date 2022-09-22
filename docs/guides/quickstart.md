# Quickstart

This tutorial shows you the quickest way to get started with ReadySet.

First, you'll start a local deployment using the ReadySet orchestrator.(1) Then you'll load sample data into the backing database, run some queries, and check their latencies. Finally, you'll cache queries and compare how quickly results are returned by ReadySet vs. the backing database.
{ .annotate }

1.  The **ReadySet orchestrator** is a command-line tool that uses Docker Compose to deploy a complete ReadySet cluster on your local machine, including:

    - The ReadySet Server, which makes a copy of your underlying database, listens to the database's replication stream for updates, and keeps queries cached in an in-memory dataflow graph.
    - The ReadySet Adapter, which handles connections from SQL clients and ORMs, forwarding uncached queries upstream and running cached queries against the ReadySet Server.
    - Grafana, which displays all queries your application sends to the Adapter, their latency, and whether or not ReadySet supports caching them.
    - Consul, Prometheus, and Vector for internal cluster state and metrics.

    The orchestrator also gives you the choice to create a new MySQL or Postgres database or connect to an existing database.

??? tip "Interested in cloud deployment?"

    You can deploy to AWS yourself using our Kubernetes Helm chart, or you can let ReadySet do the work on ReadySet Cloud.

    See [Deploy with Kubernetes](deploy-readyset-kubernetes.md) or [Deploy on ReadySet Cloud](deploy-readyset-cloud.md) for more details.

## Before you begin

- Install and start [Docker](https://docs.docker.com/get-docker/).
- Install the [MySQL shell](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) or the [Postgres shell](https://www.postgresql.org/docs/current/app-psql.html), depending on which database you plan to use.

## Step 1. Deploy ReadySet

1. Download and start the orchestrator:

    ```sh
    bash -c "$(curl -sSL https://launch.readyset.io)"
    ```

1. Follow the prompts to configure your ReadySet deployment.

    <div class="annotate" markdown>

    - Choose a backing database, either MySQL or Postgres.
    - Set a deployment name and password.(1)
    - Assign ReadySet a port to listen on.(2)
    - Choose to use a new or existing database.
    - If using an existing database, provide additional database details.
    - When asked, proceed with the current installation.(3)

    </div>

    1.  The deployment name will be a shared internal identifier across components of the deployment.

        If you use a new MySQL or Postgres database, the deployment name will also be used as the default database name, and the password will be used for both the ReadySet and database users. These details will be reflected in the connection strings provided by the operator.

    2.  This is the port that ReadySet will listen on for incoming requests from SQL clients and ORMs. The default is `3307` for MySQL and `5433` for Postgres.

        If you use a new MySQL of Postgres database, the database is accessible on `3306` for MySQL and `5432` for Postgres.

    3.  Caching is `explicit` by default, which means that ReadySet will only cache queries you tell it to. For this tutorial, it's important to keep this setting. In future testing, however, you can change this to `implicit` if you want ReadySet to attempt to cache every query that it receives, without your intervention.

        Experimental query support is `disabled` by default. For this tutorial, it's best to keep this setting.

The orchestrator then downloads the necessary images and starts a ReadySet deployment locally. When the deployment is complete, you'll see some helpful details, including:

- A pre-configured connection string for applications.
- A pre-configured command for starting the database SQL shell.
- A link to the [ReadySet dashboard](../reference/dashboard.md) showing all queries sent to ReadySet.
- A link to our [Discord Community chat](https://discord.gg/readyset).

## Step 2. Load sample data

1. Download a sample data file:

    === "MySQL"

        ``` sh
        curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-data-mysql.sql
        ```

    === "Postgres"

        ``` sh
        curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/quickstart-data-postgres.sql
        ```

2. Start the database SQL shell, using the pre-configured command printed by the orchestrator:

    === "MySQL"

        ``` sh
        mysql -h <host> -uroot -p<password> -P<port> --database=<deployment name>
        ```

    === "Postgres"

        ``` sh
        PGPASSWORD=<password> psql -h <host> -p <host> -U postgres <deployment name>
        ```

3. Load the sample data into your database:   

    === "MySQL"

        ``` sh
        source quickstart-data-mysql.sql;
        ```

    === "Postgres"

        ``` sh
        \i quickstart-data-postgres.sql
        ```

## Step 3. Run queries

Your database now contains two tables, `users` and `posts`. These tables represent a simplistic news forum, where users post articles.

1. Take a look at the schema of each table:

    === "MySQL"

        ``` sql
        DESCRIBE users;
        ```

        ``` {.text .no-copy}
        +-------+------+------+-----+---------+----------------+
        | Field | Type | Null | Key | Default | Extra          |
        +-------+------+------+-----+---------+----------------+
        | id    | int  | NO   | PRI | NULL    | auto_increment |
        | email | text | NO   |     | NULL    |                |
        +-------+------+------+-----+---------+----------------+
        ```

        ``` sql
        DESCRIBE posts;
        ```

        ``` {.text .no-copy}
        +---------+------+------+-----+---------+----------------+
        | Field   | Type | Null | Key | Default | Extra          |
        +---------+------+------+-----+---------+----------------+
        | id      | int  | NO   | PRI | NULL    | auto_increment |
        | user_id | int  | NO   | MUL | NULL    |                |
        | title   | text | NO   |     | NULL    |                |
        +---------+------+------+-----+---------+----------------+
        ```

    === "Postgres"

        ``` sh
        \d users
        ```

        ``` {.text .no-copy}
        ?1? "public.users"
         Column |  Type
        --------+---------
         id     | integer
         email  | text
        ```

        ``` sh
        \d posts
        ```

        ``` {.text .no-copy}
        ?1? "public.posts"
         Column  |  Type
        ---------+---------
         id      | integer
         user_id | integer
         title   | text
        ```

    In each table, `id` is the primary key and is an auto-incremented integer. In the `posts` table, `user_id` has a foreign key reference to `id` in the `users` table. This means that any value in `posts.user_id` must match a value in `users.id`.

2. Run a query to count how many users there are:

    === "MySQL"

        ``` sql
        SELECT COUNT(*) FROM users;
        ```

        ``` {.text .no-copy}
        +----------+
        | count(*) |
        +----------+
        |     4990 |
        +----------+
        ```

    === "Postgres"

        ``` sql
        SELECT COUNT(*) FROM users;
        ```

        ``` {.text .no-copy}
          count
         -------
           4990
        ```

3. Find out how many users have posted articles:

    === "MySQL"

        ``` sql
        SELECT COUNT(DISTINCT user_id) FROM posts;
        ```

        ``` {.text .no-copy}
        +-------------------------+
        | count(distinct user_id) |
        +-------------------------+
        |                    3166 |
        +-------------------------+
        ```

    === "Postgres"

        ``` sql
        SELECT COUNT(DISTINCT user_id) FROM posts;
        ```

        ``` {.text .no-copy}
          count
         -------
           3166        
        ```

4. Now get the titles of all articles posted by a specific user:

    === "MySQL"

        ``` sql
        SELECT title FROM posts
          JOIN users ON posts.user_id = users.id
          WHERE users.email = '936@email.com';
        ```

        ``` {.text .no-copy}
        +------------+
        | title      |
        +------------+
        | Title 1636 |
        | Title 2283 |
        | Title 3237 |
        +------------+
        ```

    === "Postgres"

        ``` sql
        SELECT title FROM posts
          JOIN users ON posts.user_id = users.id
          WHERE users.email = '936@email.com';
        ```

        ``` {.text .no-copy}
            title
         ------------
          Title 1636
          Title 2283
          Title 3237
        ```

## Step 4. Profile queries

Your local deployment includes a [Grafana dashboard](../reference/dashboard.md) that shows all queries sent through ReadySet. You'll use this dashboard to profile query latencies and identify queries to cache.

<div class="annotate" markdown>

1. In your browser, go to [localhost:4000](http://localhost:4000).

2. Under **Proxied Queries**(1), find the queries you ran.

3. For each query, note the **50p Latency** (i.e., median latency). You'll soon compare these with the latencies you get when the queries are cached with ReadySet.

4. For each query, also look at **Supported by ReadySet**. This column tells you whether a query can be cached by ReadySet.(2)

</div>

1.  "Proxied" means that ReadySet sent the queries to the backing database to return results.
2.  You can also use the [`SHOW PROXIED QUERIES`](../reference/sql-extensions.md) command to check if ReadySet supports a query.

      ReadySet is continuously expanding support for areas of the SQL language. For more details, see [Query Support](../reference/query-support.md).

## Step 5. Cache queries

1. Back in the SQL shell, run the ReadySet-specific [`CREATE CACHE`](../reference/sql-extensions.md) command to cache the queries:

    ``` sql hl_lines="2"
    CREATE CACHE FROM
      SELECT COUNT(*) FROM users; -- (1)
    ```

    1.   To cache a query, you can provide either the full `SELECT` (as shown here) or the ID that ReadySet assigns to the query. The query ID is shown both on the ReadySet dashboard and in the results of `SHOW PROXIED QUERIES`.

    ``` sql
    CREATE CACHE FROM
      SELECT COUNT(DISTINCT user_id) FROM posts;
    ```

    ``` sql
    CREATE CACHE FROM
      SELECT title FROM posts
        JOIN users ON posts.user_id = users.id
        WHERE users.email = ?;
    ```

    !!! tip "Parameterized queries"

        ReadySet supports caching both one-off queries and parameterized queries (also known as [prepared statements](https://en.wikipedia.org/wiki/Prepared_statement)). The first and second queries are one-off. The third query is parameterized because we want to make sure ReadySet returns fast results no matter which email is specified.

2. Run each query 5-10 more times. This gives ReadySet a chance to build a [dataflow graph](../concepts/dataflow.md) for the queries.

    ``` sql
    SELECT COUNT(*) FROM users;
    ```

    ``` sql
    SELECT COUNT(DISTINCT user_id) FROM posts;
    ```

    ``` sql
    SELECT title FROM posts
      JOIN users ON posts.user_id = users.id
      WHERE users.email = '936@email.com';
    ```

3. Back on the Grafana dashboard, look for the queries again. This time, you'll find them under **Cached Queries**.

4. For each query, note the extremely low **50p Latency**.

    Now that the queries are cached by ReadySet, their results are returned lightning fast, often sub-millisecond.

## Step 6. Tear down

When you're done with your local deployment:

1. Run the orchestrator again:

    ```sh
    bash -c "$(curl -sSL https://launch.readyset.io)"
    ```

2. The orchestrator will ask if you want to continue with the existing deployment. Select `yes`.

3. The orchestrator will ask what you'd like to do with the deployment. Select `Tear down the deployment`.

The orchestrator then stops the deployment and removes all of its resources.

To start a new local deployment, just run the orchestrator again.


## Next steps

- [Connect an application to your deployment](connect-an-app.md)

- [Review query support](../reference/query-support.md)

- [Learn how ReadySet works under the hood](../concepts/overview.md)
