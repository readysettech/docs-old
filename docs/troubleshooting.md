# Troubleshooting

## Is ReadySet right for my application?
You can use ReadySet for any application that would benefit from standard caching. In general, caching works best
for workloads that are *read-heavy* and that have *predictable access patterns*.

Read-heavy workloads are characterized by a high read-to-write ratio. In other words, of the requests being sent to your database,
there are more reads rather than writes. Predictable access patterns means that the queries that are being issued are non-random and repeated.

## How do I connect to ReadySet?
ReadySet supports the MySQL and Postgres wire protocols, so you can connect to your ReadySet instance as you
would connect to a standard MySQL or Postgres database. When running the ReadySet installer, the last step provides a database connection
string that you can copy into your application.  

For example:
```sh
mysql://<username>:<password>@<host-name>:<port>/<database>
```
```sh
postgresql://postgres:<password>@<host-name>:<port>/<database>
 ```
See our [connection docs](/guides/connect-an-app) for more information.

## What happens when I replace my upstream connection with a connection to ReadySet?
By default, ReadySet proxies all queries to your upstream database, so there will be no impact on your application.

## How do I cache a query in ReadySet?
Queries are cached explicitly by issuing a `CREATE CACHE` statement to ReadySet. For more information about how to cache
queries, see our [query caching syntax documentation](/using/caching).

## How do I access the ReadySet dashboard?
To access the ReadySet dashboard, visit `http://localhost:4000` in your web browser. If you’re running ReadySet on a remote
machine, you can visit port 4000 on that machine, or set up [port forwarding](/using/dashboard#port-forwarding).

## Is ReadySet receiving queries?
All queries received by ReadySet are either proxied or cached. You can see both via the ReadySet dashboard (“Proxied Queries” and
“Cached Queries” tables) or by the MySQL or Postgres command lines (by running the `SHOW PROXIED QUERIES` and `SHOW CACHES`
commands respectively).  

## How can I double check that my query is being cached in ReadySet?
To see a list of cached queries via the ReadySet dashboard, go to the “Workload Overview” page. The “Cached Queries” table  will
show you a list of queries that are being cached in ReadySet and the performance of each query. For more information on the dashboard,
you can read the full dashboard documentation here.

To see a list of cached queries via the MySQL or Postgres clients, run the `SHOW CACHES` command to see all cached queries.

## How do I stop caching a query?
To stop caching a query in ReadySet, you first need either the query ID or query text. To identify either of these, you can connect to the
ReadySet adapter and run `SHOW CACHES`.

Once you have the query ID or text, you can either run `DROP CACHE <query ID>` or `DROP CACHE <query text>` to resume proxying this query to
your upstream database.

For more information, you can read the full caching syntax documentation [here](/using/caching).
