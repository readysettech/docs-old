# Using the ReadySet Dashboard

## Viewing the Dashboard

After creating a new ReadySet instance via the installer, you can access the dashboard from your web browser by navigating to
 `http://localhost:4000`.

### Port Forwarding

If your ReadySet instance is running on a remote machine, you can use port forwarding to connect to the dashboard.
Open up a terminal and run:

`ssh -N -L 4000:localhost:4000 <user>@<remote-ip-addr>`

Then, navigate to `http://localhost:4000` on your local browser.

## Interpreting the Dashboard

### Query Overview Page

This page shows a list of proxied and cached queries and high-level performance information for both.

- **Query ID:** the ReadySet assigned identifier for proxied queries. Used to cache queries
- **Query Text:** the parameterized text for a query
- **Count:** number of times a particular query has been sent to ReadySet (both proxied and cached)
- **P50 latency (ms):** the 50th percentile query latency in milliseconds
- **P90 latency (ms):** the 90th percentile query latency in milliseconds
- **P99 latency (ms):** the 99th percentile query latency in milliseconds
- **Total Duration (ms):** the sum of the execution time for all executions of the given query
- **ReadySet supported:** indicates whether ReadySet supports a given query

### Specific Query Page

This page deep dives into the performance information for a given query.

- **Query Text:** interpretation of the query text
- **Query Running in ReadySet:** whether the query is being cached in ReadySet or proxied to the backing database
- **Query Latency:** end-to-end query latency from the time the request is received by ReadySet to when a response is returned.
- **Total Query Count:** total number of queries sent to ReadySet (both proxied and cached)

### Status Page

This page displays the current status of ReadySet and key system health metrics.

- **Readyset Started:** how long ago the ReadySet instance was started
- **Server Request Rate:** rate of HTTP requests received by the ReadySet server
- **Client Request Rate:** rate of HTTP requests received by the ReadySet adapter
- **Client Connections:** number of active connections to ReadySet
- **Snapshot in Progress:** whether ReadySet is currently snapshotting the backing database's base tables
- **Migration in Progress:** whether ReadySet is currently in the process of adding/removing a query cache
