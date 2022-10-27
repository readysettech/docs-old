# Cache Queries

Once you've started running queries against ReadySet, you can use custom SQL commands to identify the queries that ReadySet supports, cache supported queries, view existing caches, and remove caches from ReadySet.

### Identify queries to cache

To view the queries that ReadySet has proxied to the upstream database and identify whether such queries can be cached with ReadySet, use:

``` sql
SHOW PROXIED QUERIES;
```

This command returns a virtual table with 3 columns:

- **QueryID:** A unique identifier for the query.
- **Proxied Query:** The text of the query being proxied.
- **ReadySet supported:** Whether or not ReadySet can cache the query.

### Cache queries

To cache a query, use:

``` sql
CREATE CACHE [<name>] FROM <query>;
```

- `<name>` is optional. If a cache is not named, ReadySet automatically assigns an identifier.
- `<query>` is the full text of the query or the unique identifier assigned to the query by ReadySet, as seen in output of `SHOW PROXIED QUERIES`.

### View cached queries

To show all queries that have been cached, use:

``` sql
SHOW CACHES;
```

This command returns a virtual table with 2 columns:

- **Name:** The name assigned to the query by the user, or the ID assigned to the query by ReadySet.
- **Query Text:** The SQL source of the query. This is the canonical structure of the query, not the original SQL passed to ReadySet.

### Remove cached queries

To remove a cache from ReadySet, use:

``` sql
DROP CACHE <id>
```

- `<id>` is either the name assigned to the query by the user or the ID assigned to the query by ReadySet, as seen in the output of `SHOW CACHES`.

After removing a query from ReadySet, any instances of this query will be proxied to the upstream database.
