# What is ReadySet?

ReadySet is a lightweight SQL caching engine that sits between your application and database and turns even the most complex SQL reads into lightning-fast lookups. Unlike other caching solutions, ReadySet requires no changes to your application code.

## How does ReadySet work?

Based on years of dataflow research at MIT[^1], ReadySet stores the results of queries in-memory and automatically keeps queries up-to-date as the underlying database is updated. When the cache gets too full, ReadySet dynamically chooses which rows to evict. ReadySet can do this automatically because it listens to your database's replication logs.

This means:

- No extra code to keep your cache and database in sync
- No extra code to evict stale records
- No TTLs to set - your cache is as up-to-date as your replication lag

ReadySet is wire-compatible with MySQL and Postgres. For more on how ReadySet works under the hood, see [Concepts](../concepts/overview.md).

![Architecture](../assets/readyset_arch.png)

[^1]: See the [Noria](https://pdos.csail.mit.edu/papers/noria:osdi18.pdf) paper.

## When is ReadySet a good fit?

ReadySet is a good fit for read-heavy applications that use MySQL or Postgres as the backing database.

ReadySet is particularly well-suited for the following cases:

- **Reducing latency:** You want sub-millisecond query latency, but you don't want to maintain the custom application logic and infrastructure required by traditional caching solutions like Redis or Memcached.  
- **Increasing throughput:** Your database load is too high, and you want to avoid the expense of scaling or provisioning read replicas and load balancing between them.

## How do you get started?

Integrating with ReadySet is straight-forward:

<div class="annotate" markdown>

1. Deploy ReadySet and connect it to your MySQL or Postgres database.
2. Change your application's connection string to point at ReadySet.(1)
3. Profile queries in the ReadySet Dashboard.
4. Cache queries using ReadySet's custom SQL commands.

</div>

1.  This is the only required change to your application.   

To run through this process on your local machine, see the [Quickstart](quickstart.md).  

To run through this process in a cloud deployment, see [Deploy with Kubernetes](deploy-readyset-kubernetes.md) or [Deploy with ReadySet Cloud](deploy-readyset-cloud.md).
