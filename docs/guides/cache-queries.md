# Cache Queries

Once you've [identified queries](profile-queries.md) that can benefit from caching in ReadySet, use ReadySet's custom SQL commands to check if the queries are supported and then to cache supported queries in ReadySet. There are also custom SQL commands for viewing queries that are already cached, and for removing caches from ReadySet.

!!! note

    Queries can be cached in ReadySet only once all tables have finished the initial snapshotting process. To confirm that snapshotting has finished, see [Check Snapshotting](check-snapshotting.md).

## Check query support

To view all queries that ReadySet has proxied to the upstream database and check if they can be cached in ReadySet, use:

``` sql
SHOW PROXIED QUERIES;
```

To check if a specific proxied query can be cached in ReadySet, use:

``` sql
SHOW PROXIED QUERIES where query_id = <query ID>;
```

This command returns a virtual table with 3 columns:

- **QueryID:** A unique identifier for the query.
- **Proxied Query:** The text of the query being proxied.
- **ReadySet supported:** Whether or not ReadySet can cache the query.
    - If the value is `pending`, check again until you see `yes` or `no`.
    - If the value is `yes`, ReadySet can cache the query.
    - If the value is `no`, ReadySet cannot cache the query.

    !!! note

        To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../reference/sql-support/#query-caching). If an unsupported feature is important to your use case, [submit a feature request](https://github.com/readysettech/readyset/issues/new/choose).

## Cache queries

To cache a query, use:

``` sql
CREATE CACHE [ALWAYS] [<name>] FROM <query>;
```

- `<name>` is optional. If a cache is not named, ReadySet automatically assigns an identifier.
- `<query>` is the full text of the query or the unique identifier assigned to the query by ReadySet, as seen in output of `SHOW PROXIED QUERIES`.
- `ALWAYS` is optional. If the `CREATE CACHE` command is executed inside a transaction (e.g., due to an ORM), use `ALWAYS` to run the command against ReadySet; otherwise, the command will be proxied to the upstream database with the rest of the transaction. 

## View cached queries

To show all queries that have been cached, use:

``` sql
SHOW CACHES;
```

To show a specific cached query, use:

``` sql
SHOW CACHES where query_id = <query ID>;
```

This command returns a virtual table with 2 columns:

- **Name:** The name assigned to the query by the user, or the ID assigned to the query by ReadySet.
- **Query Text:** The SQL source of the query. This is the canonical structure of the query, not the original SQL passed to ReadySet.

## Remove cached queries

To remove a cache from ReadySet, use:

``` sql
DROP CACHE <id>
```

- `<id>` is either the name assigned to the query by the user or the ID assigned to the query by ReadySet, as seen in the output of `SHOW CACHES`.

After removing a query from ReadySet, any instances of this query will be proxied to the upstream database.
