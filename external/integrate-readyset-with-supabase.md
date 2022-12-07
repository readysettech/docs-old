# ReadySet

[ReadySet](https://readyset.io/) is a lightweight SQL caching engine that sits between your application and Supabase and turns even the most complex SQL reads into lightning-fast lookups. Unlike other caching solutions, ReadySet requires no changes to your application code.

This guide shows you how to integrate ReadySet Cloud (ReadySet's managed service) with your Supabase project.

## Before you begin

Note that ReadySet does not currently support [row-level security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html).

## Step 1. Collect required details

When you set up your ReadySet Cloud deployment, you'll need some basic details about your database. It's best to collect these details in advance.

1. Get your AWS region:

    1. In the Supabase Dashboard, go to **Project Settings > General**.

    1. Scroll to the **Infrastructure** area.

    1. Note the **Region**.

1. Download your Supabase SSL certificate:

    1. In the Supabase Dashboard, go to **Project Settings > Database**.

    1. Scroll down to the **SSL Connection** area.

    1. Click **Download Certificate**.

1. Get your database connection string:

    1. Scroll down to the **Connection string** area.

    1. Select **URI** and note the connection string.

        **Tip:** Be sure to note the connection string under **Connection string**, not under **Connection pooling**. To verify that you have the correct one, check for port `5432`.

## Step 2. Configure the database

ReadySet will use your database's [logical replication](https://www.postgresql.org/docs/current/logical-replication.html) stream to automatically keep your cache up-to-date as the database changes. In Supabase, logical replication is already enabled. However, you must change the `postgres` user's permissions so that ReadySet can create a replication slot.  

1. In the Supabase Dashboard, go to the **SQL Editor**.

1. Change the `postgres` user's permissions to `SUPERUSER`:

    ``` sql
    ALTER USER postgres WITH SUPERUSER;
    ```

## Step 3. Integrate ReadySet

1. [Sign up for ReadySet Cloud](](https://readysettech.typeform.com/to/BqovNk8A?typeform-source=readyset.io)).

1. ReadySet will schedule time to discuss your use case, give you an overview of the onboarding process, and ask for the database details you collected in Step 1.

1. ReadySet will then deploy your ReadySet Cloud instance.

    - At first, ReadySet will take a snapshot of your data, which can take between a few minutes to several hours, depending on the size of your dataset.

        **Warning::** Make sure there are no DDL statements in progress. Until the entire snapshot is finished, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked.

    - Once snapshotting is finished, ReadySet will send you the ReadySet connection string.

## Step 4. Cache queries

1. Once you have the ReadySet connection string, update your app to connect to ReadySet instead of the upstream database. See [Connect an App](https://docs.readyset.io/guides/connect-an-app/) for client library and ORM examples.

    **Note:** By default, ReadySet will proxy all queries to the upstream database, so changing your app to connect to ReadySet should not impact performance. You will explicitly tell ReadySet which queries to cache.   

1. Use your preferred montoring tool to identify slow queries.

1. For each query you want to cache:

    1. Connect the `psql` shell to your ReadySet Cloud instance, using the connection string that ReadySet provided:

        ``` sh
        psql '<ReadySet connection string>'
        ```

    1. Run ReadySet's custom [`SHOW PROXIED QUERIES`](https://docs.readyset.io/guides/cache-queries.md#identify-queries-to-cache) command:

        ``` sql
        SHOW PROXIED QUERIES;
        ```

    1. In the command output, find the query and check the `readyset supported` value:

        - If the value is `pending`, check again until you see `yes` or `no`.
        - If the value is `yes`, ReadySet can cache the query.
        - If the value is `no`, ReadySet cannot cache the query.

            !!! note

                To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](https://docs.readyset.io/reference/sql-support/#query-caching). If an unsupported feature is important to your use case, [submit a feature request](https://github.com/readysettech/readyset/issues/new/choose).

    1. If the query is supported, use ReadySet's custom [`CREATE CACHE`](https://docs.readyset.io/guides/cache-queries.md#cache-queries_1) command to cache the query results in ReadySet:

        ``` sql
        CREATE CACHE FROM <query>; -- (1)
        ```

        1.   You can provide either the full `SELECT` text or the query ID listed in the `SHOW PROXIED QUERIES` output.

        Caching will take a few minutes, as it constructs the initial dataflow graph for the query and adds indexes to the relevant ReadySet table snapshots, as necessary. The `CREATE CACHE` command will return once this is complete.    

    1. Use ReadySet's custom [`SHOW CACHES`](cache-queries.md#view-cached-queries) command to verify that the cache has been created for your query:

        ``` sql
        SHOW CACHES;
        ```

1. Use your preferred montoring tool to check how fast results are now returning for your cached queries.

## Next steps

- Use your **private ReadySet Slack channel** to report issues or ask questions. This Slack channel was created for you during your onboarding call with ReadySet.
- Join the [ReadySet Discord chat](https://discord.gg/readyset) to interact with the broader ReadySet community.
