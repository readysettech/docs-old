# ReadySet Concepts
The heart of ReadySet is a query engine based on **partially-stateful, streaming dataflow**.

What's that? Let's break it down. First, we'll take a look at the basics of **stateful, streaming dataflow**, then
in a later section we'll consider how to improve memory overhead using **partial state**.

## Streaming dataflow
The basic premise of [streaming dataflow](https://en.wikipedia.org/wiki/Stream_processing) is that a **series
of operations** is applied to each element of a **stream** (a given sequence of data).

### Stream

The stream that ReadySet deals with is the sequence of data changes made to your underlying database due to writes.
ReadySet receives this stream as input by registering itself as a [read replica of your primary database](https://dev.mysql.com/doc/internals/en/replication.html).
The data change stream primarily consists of **inserts of new records** to the base tables and **updates of
existing records** in the base tables.

### Operations

ReadySet applies SQL operations over this data change stream to compute the results of the SQL queries you want to cache. When ReadySet receives a new SQL query, it first creates a query plan, which consists of the ordered sequence of transformations over the data in the base tables that needs to be applied to compute the correct query result. ReadySet then instantiates a long-lived **dataflow graph** that actually executes the operations in the query plan over the incoming data stream.

The entry points of ReadySet's dataflow graph are referred to as **base table nodes**, which represent the application base tables
and funnel in incoming data changes to the rest of the graph.

Below the base table nodes are the **internal nodes** that compute SQL operators (e.g., joins, aggregates, projections, and filters)
over the incoming stream of data changes. These nodes are stateful in that they track the results of these operations, keeping
them up to date in real-time. Whenever the results of the operation change due to the incoming data changes, these internal nodes
emit the updated results and propagate them downstream in the graph.

Since these internal nodes are connected together based on a query plan, the leaf nodes of the graph (referred to as **reader nodes**)
cache the final query results, and all non-leaf nodes effectively cache intermediate state.

![High Level](/high-level-graph.png)

## Putting it all together
As writes are applied to your database, the resulting data changes are immediately replicated to ReadySet. ReadySet incrementally
updates its cached query results to reflect these changes, thus replacing any hand-written cache eviction logic. When using ReadySet,
you just write traditional SQL queries, and ReadySet will keep the results up-to-date for you.
