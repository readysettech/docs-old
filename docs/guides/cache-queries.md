# Caching Syntax

Once your ReadySet instance is up and running, you can connect to it via the MySQL or Postgres command lines and run
any of the following commands.


## Showing Proxied Queries

```js
SHOW PROXIED QUERIES
```

This command returns a virtual table containing all queries that are being forwarded to the upstream database instead of
being cached in ReadySet. The table has three columns:
- **QueryID:** an assigned identifier for this query. Needed when caching queries.
- **Proxied Query:** the text of the query being proxied
- **ReadySet supported:** whether we can cache this query or not, based on a dry run of the query


## Caching Queries

### Create a Cached Query
After identifying a query to cache in ReadySet, you can connect to ReadySet and cache it with this command, where Query ID is the unique identifier provided by ReadySet. Name is an optional field, if no name is provided, we automatically generate an identifier.

```js
CREATE CACHE <name> FROM <query ID>
```

### List All Cached Queries

```js
SHOW CACHES
```

This command returns a virtual table containing all queries cached in the ReadySet cluster. The table will have two columns:
- **Name:** the name assigned to the query, either explicitly passed by the user or generated by ReadySet.
- **Query Text:**  the SQL source of the query. This is the canonical structure of the query, not the original SQL passed to Readyset.


## Removing Cached Queries

After caching a query, if you’d like to remove it from ReadySet, the command is below. After removing a query from ReadySet, any instances of this query will be proxied to your upstream database.

```js
DROP CACHE <id>
```