# readyset-server

The `readyset-server` command starts the ReadySet Server.

!!! note

    This command is used only when running the ReadySet Server and Adapter as separate processes on separate machines. To run the ReadySet Server and Adapter as a single process, use the [`readyset`](readyset.md) command with the `--standalone` option.

## Usage

Start the ReadySet Server:

``` {.text .no-copy}
readyset-server [OPTIONS]
```

Start the ReadySet Adapter:

``` {.text .no-copy}
readyset [OPTIONS, excluding --standalone]
```

View help:

```
readyset-server --help
```

## Options

#### `--address`, `-a`

<div class="option-details" markdown="1">
The IP address/hostname and port that the ReadySet Server listens on.

**Env variable:** `LISTEN_ADDRESS`
</div>

#### `--authority`

<div class="option-details" markdown="1">
The external authority for a [distributed ReadySet deployment](../../guides/production-notes.md#scale-out). The authority handles node discovery, leader election, and consensus and manages internal state and metrics.

**Possible values:** `"consul"`, `"zookeeper"` (deprecated)

**Default:** `"consul"`

**Env variable:** `AUTHORITY`
</div>

#### `--authority-address`

<div class="option-details" markdown="1">
The IP address/hostname and port of the external authority.

**Env variable:** `AUTHORITY_ADDRESS`
</div>

#### `--cannot-become-leader`

<div class="option-details" markdown="1">
When running multiple ReadySet Servers, prevent this Server from ever being elected as leader.
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
Disable verification of SSL certificates supplied by the upstream database (Postgres only, ignored for MySQL).

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

#### `--eviction-policy`

<div class="option-details" markdown="1">
When possible, ReadySet stores only certain results sets for a query in memory. For example, if a query is [parameterized](../sql-support.md#parameters) on user IDs, ReadySet would only cache the results of that query for the active subset of users, since they are the ones issuing requests. This is referred to as "partial materialization".

The `--eviction-policy` option determines the strategy for evicting cache entries from partial materializations once the overall memory limit (see [`--memory`](#-memory-m)) has been surpassed.

**Possible values:** `"random"`, `"lru"`, `"generational"`

**Default:** `"random"`
</div>

#### `--external-address`

<div class="option-details" markdown="1">
The IP address/hostname to advertise to ReadySet instances running in the same deployment. This also defines the IP address/hostname of the Prometheus endpoint for [ReadySet metrics](http://docs/rustdoc/readyset_client/metrics/recorded/index.html).

**Default**: Address from `--address`

**Env variable:** `EXTERNAL_ADDRESS`
</div>

#### `--external-port`, `-p`

<div class="option-details" markdown="1">
The port to advertise to ReadySet instances running in the same deployment. This also defines the port of the Prometheus endpoint for [ReadySet metrics](http://docs/rustdoc/readyset_client/metrics/recorded/index.html).

**Default**: `6033`
</div>

#### `--forbid-full-materialization`

<div class="option-details" markdown="1">
ReadySet must sometimes store the entire result set for a query in memory, for example, when there is no `WHERE` filter or when the `WHERE` filter is not [parameterized](../sql-support.md#parameters) (by the user or by ReadySet). This is referred to as "full materialization".

The `--forbid-full-materialization` option prevents ReadySet from caching queries that would be fully materialized.

**Env variable:** `FORBID_FULL_MATERIALIZATION`

!!! tip

    Consider passing this option when ReadySet Adapters use the `"inrequestpath"` or `"async"` [query caching mode](readyset.md#-query-caching). In both cases, queries are cached by ReadySet automatically, and if too many queries are fully materialized, you can run into memory issues, especially because cache entries of fully materialized queries will never get evicted (i.e., the [`--eviction-policy`](#-eviction-policy) applies only to partially materialized queries).
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
The amount of memory, in bytes, available to the ReadySet Server.

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

#### `--no-readers`

<div class="option-details" markdown="1">
Do not run reader nodes on this instance. Reader nodes are the part of the dataflow graph that serve cached results for a query.
</div>

#### `--persistence-threads`

<div class="option-details" markdown="1">
Number of background threads used by RocksDB, the storage engine for ReadySet's snapshot of upstream database tables.

**Default:** `6`
</div>

#### `--prometheus-metrics`

<div class="option-details" markdown="1">
Output ReadySet metrics to the Prometheus endpoint at `<metrics address>/metrics`. The metrics address is defined by [`--external-address`](#-external-address) and [`--external-port`](#-external-port).

**Env variable:** `PROMETHEUS_METRICS`
</div>

#### `--quorum`, `-q`

<div class="option-details" markdown="1">
For a [distributed ReadySet deployment](../../guides/production-notes.md#multi-region) with multiple ReadySet Server instances, the number of ReadySet Server instances. ReadySet will wait until this number is reached before accepting requests.

**Default:** `1`

**Env variable:** `NORIA_QUORUM`
</div>

#### `--reader-only`

<div class="option-details" markdown="1">
Run only reader nodes on this instance. Reader nodes are the part of the dataflow graph that serve cached results for a query.
</div>

#### `--replication-pool-size`

<div class="option-details" markdown="1">
The number of connections to the upstream database for snapshotting and replication.

**Default:** `50`

!!! note

    This can be set as high as the number of tables you want ReadySet to snapshot/replicate. However, note that the more connections you use for snapshotting/replication, the higher the load on your upstream database.  
</div>

#### `--replication-tables`

<div class="option-details" markdown="1">
By default, ReadySet attempts to snapshot and replicate all tables in the database specified in [`--upstream-db-url`](#-upstream-db-url). However, if the queries you want to cache in ReadySet access only a subset of tables in the database, you can use this option to narrow the scope accordingly. Filtering out tables that will not be used in caches will speed up the snapshotting process.

This option accepts a comma-separated list of `<schema>.<table>` (specific table in a schema) or `<schema>.*` (all tables in a schema) for Postgres and `<database>.<table>` for MySQL.  

**Env variable:** `REPLICATION_TABLES`
</div>

#### `--snapshot-report-interval-secs`

<div class="option-details" markdown="1">
The time, in seconds, between logging the [snapshotting progress](../../guides/check-snapshotting.md) and estimated time remaining for each table.

**Default:** `30`
</div>

#### `--ssl-root-cert`

<div class="option-details" markdown="1">
Path to the PEM or DER root certificate that the upstream database connection will trust.

**Env variable:** `SSL_ROOT_CERT`
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

#### `--upstream-db-url`

<div class="option-details" markdown="1">
The URL for connecting ReadySet to to the upstream database. This connection URL includes the username and password for ReadySet to authenticate with as well as the database to snapshot/replicate.

**Env variable:** `UPSTREAM_DB_URL`

!!! tip

    By default, ReadySet attempts to snapshot and replicate all tables in the database specified in [`--upstream-db-url`](#-upstream-db-url). However, if the queries you want to cache in ReadySet access only a subset of tables in the database, you can use the [`--replication-tables`](#-replication-tables) option to narrow the scope accordingly. Filtering out tables that will not be used in caches will speed up the snapshotting process.
</div>

#### `--version`, `V`

<div class="option-details" markdown="1">
Print ReadySet version information.
</div>

#### `--volume-id`

<div class="option-details" markdown="1">

The volume associated with a ReadySet Server.

For a [distributed ReadySet deployment](../../guides/production-notes.md#multi-region) with multiple ReadySet Servers, snapshotted tables are scheduled, round-robin, onto volumes associated with Server instances. If a Server restarts, the Server must know which volume contains its portion of the snapshot.

**Env variable:** `VOLUME_ID`
</div>

## Examples

These examples focus on a [distributed ReadySet deployment](../../guides/production-notes.md#scale-out) (i.e., ReadySet Server and Adapter running as distinct processes and separate machines). For running a standard ReadySet deployment, see the [`readyset` examples](readyset.md#examples).

### Start ReadySet

1. Start an instance of Consul to serve as the external authority for node discovery, leader election, and consensus, and to manage internal state and metrics.

1. Start the ReadySet Server:

    === "Postgres"

        ``` shell
        readyset-server \
        --deployment="<deployment name>" \
        --upstream-db-url="postgresql://<db user>:<db password>@<db address>:5432/<database>" \
        --query-caching="<caching mode>" \
        --username=<readyset user> \
        --password=<readyset password> \
        --address=<readyset server address> \
        --authority-address=<consul address> \
        >> logs/readyset.log 2>&1 &
        ```

    === "MySQL"

        ``` shell
        readyset-server \
        --deployment="<deployment name>" \
        --upstream-db-url="mysql://<db user>:<db password>@<db address>:3306/<database>" \
        --query-caching="<caching mode>" \
        --username=<readyset user> \
        --password=<readyset password> \
        --address=<readyset server address> \
        --authority-address=<consul address>
        >> logs/readyset.log 2>&1 &
        ```

1. Start one of more ReadySet Adapters:

    === "Postgres"

        ``` shell
        readyset \
        --deployment="<deployment name>" \
        --database-type=postgresql \
        --username=<readyset user> \
        --password=<readyset password> \
        --address=<readyset adapter address> \
        --authority-address=<consul address>
        >> logs/readyset.log 2>&1 &
        ```

    === "MySQL"

        ``` shell
        readyset-server \
        --deployment="<deployment name>" \
        --database-type=mysql \
        --username=<readyset user> \
        --password=<readyset password> \
        --address=<readyset server address> \
        --authority-address=<consul address>
        >> logs/readyset.log 2>&1 &
        ```

### Print version information

``` shell
readyset-server --version
```

``` {.text .no-copy}
readyset-server
release-version: beta-2023-01-18
commit_id:       de35883e248180c7e3f2f7913c0d1c2b371e53ec
platform:        aarch64-apple-darwin
rustc_version:   rustc 1.64.0-nightly (fe3342816 2022-08-01)
profile:         release
opt_level:       3
```
