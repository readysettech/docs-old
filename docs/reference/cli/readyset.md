# readyset

The `readyset` command starts the ReadySet Server and Adapter as a single process on a single machine (with the `--standalone` option) or starts the ReadySet Adapter as a distinct process from the ReadySet Server ([`readyset-server`](readyset-server.md)).

## Usage

Start the ReadySet Server and Adapter as a single process:

``` {.text .no-copy}
readyset --standalone [OPTIONS]
```

Start the ReadySet Adapter as a distinct process, after starting the ReadySet Server:

``` {.text .no-copy}
readyset-server [OPTIONS]
readyset [OPTIONS, excluding --standalone]
```

View help:

``` {.text .no-copy}
readyset --help
```

## Options

#### `--address`, `-a`

<div class="option-details" markdown="1">
The IP address/hostname and port that ReadySet listens on.

**Env variable:** `LISTEN_ADDRESS`
</div>

#### `--allow-unauthenticated-connections`

<div class="option-details" markdown="1">
Don't require authentication for any client connections. When passed, `--username` and `--password` are ignored.

**Env variable:** `ALLOW_UNAUTHENTICATED_CONNECTIONS`
</div>

#### `--authority`

<div class="option-details" markdown="1">
The external authority for a distributed ReadySet deployment. The authority handles node discovery, leader election, and consensus and manages internal state and metrics.

This option is ignored when `--standalone` is passed. In that case, the ReadySet Server and Adapter are run as a single process, and no external authority is required.

**Possible values:** `"consul"`, `"zookeeper"` (deprecated)

**Default:** `"consul"`

**Env variable:** `AUTHORITY`
</div>

#### `--authority-address`

<div class="option-details" markdown="1">
The IP address/hostname and port of the external authority.

This option is ignored when `--standalone` is passed. In that case, the ReadySet Server and Adapter are run as a single process, and no external authority is required.

**Env variable:** `AUTHORITY_ADDRESS`
</div>

#### `--database-type`

<div class="option-details" markdown="1">
The database engine that ReadySet is integrating with.

**Possible values:** `"postgresql"`, `"mysql"`

**Env variable:** `DATABASE_TYPE`
</div>

#### `--db-dir`

<div class="option-details" markdown="1">
The path to the directory where ReadySet stores replicated table data.

**Default:** Current working directory

**Env variable:** `DB_DIR`
</div>

#### `--deployment`

<div class="option-details" markdown="1">
A unique identifier for the ReadySet deployment.

**Env variable:** `DEPLOYMENT`
</div>

#### `--disable-telemetry`

<div class="option-details" markdown="1">
Don't sent anonymous [telemetry data](../telemetry.md) to ReadySet.

**Env variable:** `DISABLE_TELEMETRY`
</div>

#### `--disable-upstream-ssl-verification`

<div class="option-details" markdown="1">
Disable verification of SSL certificates supplied by the upstream database on connections to replicate data and proxy queries (Postgres only, ignored for MySQL).

**Env variable:** `DISABLE_UPSTREAM_SSL_VERIFICATION`

!!! warning

    If invalid certificates are trusted, any certificate for any site will be trusted. Use this option with caution.
</div>

#### `--durability`

<div class="option-details" markdown="1">
The durability of the tables that ReadySet replicates from the upstream database as the basis for caching query results.  

**Possible values:**

- `"persistent"`: Store replicated tables on disk (at the location specified by [`--db-dir`](#-db-dir)). Do not delete the data when the ReadySet Server is stopped. Suitable for production deployments.
- `"ephemeral"`: Store replicated tables on disk (at the location specified by [`--db-dir`](#-db-dir)). Delete the data when the ReadySet Server is stopped. Suitable for testing only.
- `"memory"`: Store replicated tables entirely in memory. Suitable for testing only.

**Default:** `"persistent"`
</div>

#### `--embedded-readers`

<div class="option-details" markdown="1">
For a distributed ReadySet deployment, store cached query results with the Adapter instead of the Server.

To use this option, you must pass `--no-readers` and `--reader-replicas` when starting [`readyset-server`](readyset-server.md).

**Env variable:** `EMBEDDED_READERS`
</div>

#### `--eviction-policy`

<div class="option-details" markdown="1">
When possible, ReadySet stores only certain results sets for a query in memory. For example, if a query is [parameterized](../sql-support.md#parameters) on user IDs, ReadySet would only cache the results of that query for the active subset of users, since they are the ones issuing requests. This is referred to as "partial materialization".

The `--eviction-policy` option determines the strategy for evicting cache entries from partial materializations once the overall memory limit (see [`--memory`](#-memory-m)) has been surpassed.

**Possible values:** `"random"`, `"lru"`, `"generational"`

**Default:** `"random"`
</div>

#### `--forbid-full-materialization`

<div class="option-details" markdown="1">
ReadySet must sometimes store the entire result set for a query in memory, for example, when there is no `WHERE` filter or when the `WHERE` filter is not [parameterized](../sql-support.md#parameters) (by the user or by ReadySet). This is referred to as "full materialization".

The `--forbid-full-materialization` option prevents ReadySet from caching queries that would be fully materialized.

**Env variable:** `FORBID_FULL_MATERIALIZATION`

!!! tip

    Consider passing this option when [`--query-caching`](#-query-caching) is set to `"inrequestpath"` or `"async"`. In both cases, queries are cached by ReadySet automatically, and if too many queries are fully materialized, you can exhaust memory, especially because cache entries of fully materialized queries will never get evicted (i.e., the [`--eviction-policy`](#-eviction-policy) applies only to partially materialized queries).
</div>

#### `--help`, `-h`

<div class="option-details" markdown="1">
Print help information.
</div>

#### `--log-format`

<div class="option-details" markdown="1">
Format to use when emitting log events. See the [docs for the tracing library](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/fmt/index.html#formatters) for details.

**Possible values:** `"compact"`, `"full"`, `"pretty"`, `"json"`

**Default:** `"full"`

**Env variable:** `LOG_FORMAT`
</div>

#### `--log-level`

<div class="option-details" markdown="1">
The [severity level(s)](https://docs.rs/tracing-core/0.1.30/tracing_core/metadata/struct.Level.html#implementations) to include in ReadySet logs. Messages at the specified and more severe levels are included. For example, when set to `INFO`, messages at the `INFO`, `WARN`, and `ERROR` levels are included.

Possible values, from most to least severe:

- `ERROR`: Used for hazardous situations that require special handling, where normal operation cannot proceed as expected.   
- `WARN`: Used for potentially hazardous situations that may require special handling.
- `INFO`: Used for information messages that do not require action.
- `DEBUG`: Used for lower priority information.
- `TRACE`: Used for very low priority, often extremely verbose information.

    !!! note

        The `TRACE` level is not available for [official releases of ReadySet](../../releases/readyset-core.md), or for binaries built with the `--release` flag.

        Also, `--log-level` can be set to a comma-separated list of directives for debugging during development. For the directive syntax, see the [docs for the tracing library](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html).

**Default:** `INFO`

**Env variable:** `LOG_LEVEL`
</div>

#### `--memory`, `-m`

<div class="option-details" markdown="1">
The amount of memory, in bytes, available to ReadySet.

This memory limit accounts for all memory use, including partial materializations (i.e., queries for which ReadySet stores only part of the result set), full materializations (i.e., queries for which ReadySet stores the entire result set), and other parts of the ReadySet process (e.g., RocksDB).

Once memory usage surpasses this limit, ReadySet starts evicting cache entries from partial materializations based on the [`--eviction-policy`](#-eviction-policy).

**Default:** `0` (unlimited)

**Env variable:** `NORIA_MEMORY_BYTES`

!!! tip

    For production deployments, start by setting this to 60-80% of the machine's total memory. Then run the system under load, observe, and increase or decrease as needed.
</div>

#### `--memory-check-every`

<div class="option-details" markdown="1">
The frequency, in seconds, at which to check memory usage by ReadySet. Once usage surpasses the limit set in [`--memory`](#-memory-m), ReadySet starts evicting cache entries for partial materializations based on the [`--eviction-policy`](#-eviction-policy).

**Default:** `1`

**Env variable:** `MEMORY_CHECK_EVERY`
</div>

#### `--metrics-address`

<div class="option-details" markdown="1">
The IP address/hostname and port of the Prometheus endpoint for [ReadySet metrics](http://docs/rustdoc/readyset_client/metrics/recorded/index.html).

This option is ignored unless [`--prometheus-metrics`](#-prometheus-metrics) is passed. Also, when running a distributed ReadySet deployment, this option determines the Prometheus endpoint for the ReadySet Adapter only. The [`--external-address`](readyset-server.md#-external-address) option for the `readyset-server` command determines the Prometheus endpoint for the ReadySet Server.

**Default:** `0.0.0.0:6034`

**Env variable:** `METRICS_ADDRESS`
</div>

#### `--migration-task-interval`

<div class="option-details" markdown="1">
When [`--query-caching`](#-query-caching) is set to `"explicit"`, the frequency, in milliseconds, at which to check whether queries that ReadySet has proxied to the upstream database are [supported by ReadySet](../sql-support/#query-caching).

After this check is run on a query, [`SHOW PROXIED QUERIES`](../../guides/cache-queries/#check-query-support) returns either `yes` or `no` for `readyset supported`. Before this check is run on a query, or when this check fails for a query (e.g., because it references tables that have not finished snapshotting), `SHOW PROXIED QUERIES` returns `pending` for `readyset supported`.

**Default:** `20000`

**Env variable:** `MIGRATION_TASK_INTERVAL`
</div>

#### `--non-blocking-reads`

<div class="option-details" markdown="1">
When ReadySet cannot return results for a cached query (i.e., a cache miss), proxy the query to the upstream database while ReadySet fills the cache. If this option is not passed, ReadySet will not return results until the cache is ready.

**Env variable:** `NON_BLOCKING_READS`

!!! note

    This option improves performance for cache misses but at the cost of increasing the load on the upstream database.
</div>

#### `--password`

<div class="option-details" markdown="1">
The password for authenticating connections to ReadySet. This can differ from the password in the database connections string in [`--upstream-db-url`](#-upstream-db-url).

This option is ignored when [`--allow-unauthenticated-connections`](#-allow-unauthenticated-connections) is passed.    

**Default:** The username for the upstream database in [`--upstream-db-url`](#-upstream-db-url).

**Env variable:** `ALLOWED_PASSWORD`
</div>

#### `--persistence-threads`

<div class="option-details" markdown="1">
Number of background threads used by RocksDB, the storage engine for ReadySet's snapshot of upstream database tables.

**Default:** `6`
</div>

#### `--prometheus-metrics`

<div class="option-details" markdown="1">
Output ReadySet metrics to the Prometheus endpoint at `<metrics address>/metrics`. The metrics address is defined by [`--metrics-address`](#-metrics-address).

**Env variable:** `PROMETHEUS_METRICS`
</div>

#### `--query-caching`

<div class="option-details" markdown="1">
The query caching mode for ReadySet.

**Possible values:**

- `"explicit"`: ReadySet does not automatically cache queries. Instead, users use the [`CREATE CACHE`](../../guides/cache-queries/#cache-queries_1) command to cache queries.
- "`inrequestpath`: ReadySet caches [supported queries](../reference/sql-support/#query-caching) automatically but blocks queries from returning results until the cache is ready.
- "`async`": ReadySet caches [supported queries](../reference/sql-support/#query-caching) automatically but proxies queries to the upstream database until the cache is ready.

**Default:** `"async"`

**Env variable:** `QUERY_CACHING`

!!! tip

    For most deployments, `explicit` mode is recommended, as it gives you the most flexibility and control.
</div>

#### `--query-log`

<div class="option-details" markdown="1">
Include query-specific execution details in Prometheus metrics.

To use this option, you must pass [`--prometheus-metrics](#-prometheus-metrics) as well.

**Env variable:** `QUERY_LOG`
</div>

#### `--query-log-ad-hoc`

<div class="option-details" markdown="1">
Include execution details for ad-hoc queries in Prometheus metrics. Ad-hoc queries are those that do not use [parameters](../sql-support.md#parameters).

To use this option, you must pass [`--query-log](#-query-log) as well.

**Env variable:** `QUERY_LOG_AD_HOC`
</div>

#### `--quorum`, `-q`

<div class="option-details" markdown="1">
For a distributed ReadySet deployment with multiple ReadySet Server instances, the number of ReadySet Server instances. ReadySet will wait until this number is reached before accepting requests.

**Default:** `1`

**Env variable:** `NORIA_QUORUM`
</div>

#### `--replication-pool-size`

<div class="option-details" markdown="1">
The number of connections to the upstream database for snapshotting and replication.

**Default:** `50`

!!! warning

    This can be set as high as the number of tables you want ReadySet to snapshot/replicate. However, more connections will increase both the load on your upstream database and memory usage by ReadySet.
</div>

#### `--replication-tables`

<div class="option-details" markdown="1">
By default, ReadySet attempts to snapshot and replicate all tables in the database specified in [`--upstream-db-url`](#-upstream-db-url). However, if the queries you want to cache in ReadySet access only a subset of tables in the database, you can use this option to narrow the scope accordingly. Filtering out tables that will not be used in caches will speed up the snapshotting process.

This option accepts a comma-separated list of `<schema>.<table>` (specific table in a schema) or `<schema>.*` (all tables in a schema) for Postgres and `<database>.<table>` for MySQL.  

**Env variable:** `REPLICATION_TABLES`
</div>

#### `--snapshot-report-interval-secs`

<div class="option-details" markdown="1">
The time, in seconds, between logging the [snapshotting progress](../../guides/cache/check-snapshotting.md) and estimated time remaining for each table.

**Default:** `30`
</div>

#### `--ssl-root-cert`

<div class="option-details" markdown="1">
Path to the PEM or DER root certificate that the upstream database connection will trust.

**Default:** System root store

**Env variable:** `SSL_ROOT_CERT`
</div>

#### `--standalone`

<div class="option-details" markdown="1">
Run the ReadySet Server and Adapter as a single process. When this option is not passed, the `readyset` command starts just ReadySet Adapter. In this case, the ReadySet Server must be started first via the [`readyset-server`](readyset-server.md) command.

**Env variable:** `STANDALONE`
</div>

#### `--tracing-host`

<div class="option-details" markdown="1">
When using open telemetry, the IP address/hostname and port of the telemetry server to send traces/spans to.

**Env variable:** `TRACING_HOST`
</div>

#### `--tracing-sample-percent`

<div class="option-details" markdown="1">
The percent of traces to send to the open telemetry server.

To use this option, you must set [`--tracing-host`](#-tracing-host).

**Possible values:** Between `0.0` and `100.0`

**Default:** `0.01`

**Env variable:** `TRACING_SAMPLE_PERCENT`
</div>

#### `--unsupported-set-mode`

<div class="option-details" markdown="1">
How ReadySet behaves when receiving unsupported `SET` statements.

**Possible values:**

-  `"error"`: Return an error to the client.
- `"proxy"`: Proxy all subsequent statements to the upstream database.

**Default:** `"error"`

**Env variable:** `UNSUPPORTED_SET_MODE`
</div>

#### `--upstream-db-url`

<div class="option-details" markdown="1">
The URL for connecting ReadySet to to the upstream database. This connection URL includes the username and password for ReadySet to authenticate with as well as the database to snapshot/replicate.

**Env variable:** `UPSTREAM_DB_URL`

!!! tip

    By default, ReadySet attempts to snapshot and replicate all tables in the database specified in [`--upstream-db-url`](#-upstream-db-url). However, if the queries you want to cache in ReadySet access only a subset of tables in the database, you can use the [`--replication-tables`](#-replication-tables) option to narrow the scope accordingly. Filtering out tables that will not be used in caches will speed up the snapshotting process.
</div>

#### `--username`, `-u`

<div class="option-details" markdown="1">
The username for authenticating connections to ReadySet. This can differ from the username in the database connections string in [`--upstream-db-url`](#-upstream-db-url).

This option is ignored when [`--allow-unauthenticated-connections`](#-allow-unauthenticated-connections) is passed.

**Default:** The username for the upstream database in [`--upstream-db-url`](#-upstream-db-url).

**Env variable:** `ALLOWED_USERNAME`
</div>

#### `--version`, `V`

<div class="option-details" markdown="1">
Print ReadySet version information. See the [example](#print-version-information) below.

!!! tip

    You can also use the custom `SHOW READYSET VERSION` SQL command to print ReadySet version information.
</div>

#### `--views-polling-interval`

<div class="option-details" markdown="1">
For a distributed ReadySet deployment with multiple ReadySet Adapters, each Adapter needs to know about the caches on the ReadySet Server. This flag sets the interval, in seconds, at which to poll the ReadySet Server.

This option is not relevant when using [`--embedded-readers`](#-embedded-readers).

**Default:** `300`

**Env variable:** `OUTPUTS_POLLING_INTERVAL`
</div>

## Examples

These examples focus on running a standard ReadySet deployment (i.e., ReadySet Server and Adapter running as a single process on a single machine). For running a distributed ReadySet deployment, see the [`readyset-server` examples](readyset-server.md#examples).

### Start ReadySet

=== "Postgres"

    ``` shell
    readyset \
    --standalone \
    --deployment="<deployment name>" \
    --upstream-db-url="postgresql://<db user>:<db password>@<db address>:5432/<database>" \
    --database-type=postgresql \
    --query-caching="<caching mode>" \
    --username=<readyset user> \
    --password=<readyset password> \
    --address=<readyset address> \
    >> logs/readyset.log 2>&1 &
    ```

=== "MySQL"

    ``` shell
    readyset \
    --standalone \
    --deployment="<deployment name>" \
    --upstream-db-url="mysql://<db user>:<db password>@<db address>:3306/<database>" \
    --database-type=mysql \
    --query-caching="<caching mode>" \
    --username=<readyset user> \
    --password=<readyset password> \
    --address=<readyset address> \
    >> logs/readyset.log 2>&1 &
    ```

### Output metrics to Prometheus

To output ReadySet metrics to Prometheus, pass `--metrics-address` and `--prometheus-metrics`. To include query-specific execution details, pass `--query-log` and `--query-log-ad-hoc` as well.

=== "Postgres"

    ``` shell
    readyset \
    --standalone \
    --deployment="<deployment name>" \
    --upstream-db-url="postgresql://<db user>:<db password>@<db address>:5432/<database>" \
    --database-type=postgresql \
    --query-caching="<caching mode>" \
    --username=<readyset user> \
    --password=<readyset password> \
    --address=<readyset address> \
    --prometheus-metrics \
    --metrics-address=<prometheus address> \
    --query-log \
    --query-log-ad-hoc \
    >> logs/readyset.log 2>&1 &
    ```

=== "MySQL"

    ``` shell
    readyset \
    --standalone \
    --deployment="<deployment name>" \
    --upstream-db-url="mysql://<db user>:<db password>@<db address>:3306/<database>" \
    --database-type=mysql \
    --query-caching="<caching mode>" \
    --username=<readyset user> \
    --password=<readyset password> \
    --address=<readyset address> \
    --prometheus-metrics \
    --metrics-address=<prometheus address> \
    --query-log \
    --query-log-ad-hoc \
    >> logs/readyset.log 2>&1 &
    ```

### Print version information

To print ReadySet version information, pass the `--version` flag:

``` shell
readyset --version
```

``` {.text .no-copy}
readyset
release-version: beta-2023-02-15
commit_id:       0f40cee0b4583d559d247077b7c140dce6977f00
platform:        x86_64-unknown-linux-gnu
rustc_version:   rustc 1.64.0-nightly (fe3342816 2022-08-01)
profile:         release
opt_level:       3
```

Alternatively, you can connect a SQL shell to ReadySet and run the following custom SQL command:

``` sql
SHOW READYSET VERSION;
```

``` {.text .no-copy}
ReadySet      |             Version Information
--------------------+---------------------------------------------
release version    | beta-2023-02-15
commit id          | 0f40cee0b4583d559d247077b7c140dce6977f00
platform           | x86_64-unknown-linux-gnu
rustc version      | rustc 1.64.0-nightly (fe3342816 2022-08-01)
profile            | release
optimization level | 3
(6 rows)
```
