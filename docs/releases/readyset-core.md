# ReadySet Core Releases

ReadySet releases a new version of ReadySet Core on a weekly basis. This page summarizes the changes in each version and links to binaries and docker images.

## beta-2022-11-01

!!! warning

    Beta versions of ReadySet are backward-incompatible. To upgrade between beta versions, you must therefore clear all data files. Rolling upgrades will be supported with future ReadySet major releases.

### Downloads

=== ":material-linux: Linux"

    Binary (linux-x84_64) | Sha256Sum
    ------------------------------|----------
    [ReadySet Server](https://github.com/readysettech/readyset/files/9910818/readyset-server-beta-2022-11-01.linux-x86_64.tar.gz) | ea2b82f1faedf5836f704b496277d44906ad85a259dae7631e4749a40f9ba6b6
    [ReadySet Adapter for MySQL](https://github.com/readysettech/readyset/files/9910814/readyset-mysql-beta-2022-11-01.linux-x86_64.tar.gz) | 7aaeba77e70fa5c8f64b0d3ab1603365ae25b3f9bf4d9048a7b84cf63744b73a
    [ReadySet Adapter for Postgres](https://github.com/readysettech/readyset/files/9910812/readyset-psql-beta-2022-11-01.linux-x86_64.tar.gz) | 7f474cb5c7fc9f799fd84be735660e0abf7595ff108afaabe8c502737c2ffc76

=== ":material-apple: Mac"

    Binary (darwin-arm64) | Sha256Sum
    ------------------------------|----------
    [ReadySet Server](https://github.com/readysettech/readyset/files/9974664/readyset-server-beta-2022-11-01.darwin-arm64.tar.gz) | 8a204cd07b85fbbc375ee7e2c9b87ce44b6df3a2dab8e78454d2047f7c02cfd0
    [ReadySet Adapter for MySQL](https://github.com/readysettech/readyset/files/9974662/readyset-mysql-beta-2022-11-01.darwin-arm64.tar.gz) | 44ba62376b0a34fd099cd9c7b83fbb2714a868615d2792e63104b5a6862759b4
    [ReadySet Adapter for Postgres](https://github.com/readysettech/readyset/files/9974663/readyset-psql-beta-2022-11-01.darwin-arm64.tar.gz) | cc220b6d1dfba79e9a0ad9946205000a072fd29fdcd09d6f510842fde827066f

=== ":material-docker: Docker"

    - ReadySet Server (linux-x84_64)
        ``` sh
        docker pull public.ecr.aws/readyset/readyset-server:beta-2022-11-01
        ```

    - ReadySet Adapter (linux-x84_64)
        ``` sh
        docker pull public.ecr.aws/readyset/readyset-adapter:beta-2022-11-01
        ```

### Changes

Since first announcing ReadySet Core in [July 2022](https://readyset.io/blog/readyset-core), ReadySet has made steady progress on increasing SQL support and improving deployment options, including the following highlights:

**SQL support**

Area | Description
-----|------------
[Data types](../reference/sql-support.md#data-types) | ReadySet can now replicate tables with even more MySQL and Postgres data types, including `DATE` types, the MySQL `ENUM` type, and the Postgres `ARRAY` and `CITEXT` types.
[Table namespaces](../reference/sql-support.md#namespaces) | ReadySet can now replicate tables in multiple schemas of a Postgres database.
[Schema changes](../reference/sql-support.md#schema-changes) | When ReadySet receives certain `ALTER TABLE` schema change commands via the replication stream, including `ADD COLUMN` and `DROP COLUMN`, ReadySet now updates its snapshot and clears all cached queries for the affected table.
[Query caching](../reference/sql-support.md#query-caching) | ReadySet can now cache the results of `SELECT` queries containing the `HAVING` clause or subqueries in the `FROM` clause. In addition, all queries that ReadySet does not support are now proxied to the upstream database.

**Deployment**

Area | Description
-----|------------
[Helm chart](../guides/deploy-readyset-kubernetes.md) | ReadySet's new Helm chart lets you quickly deploy ReadySet Core into a Kubernetes cluster in front of an existing Amazon RDS database. If you don't want to run ReadySet yourself, consider signing up for a fully-managed deployment on [ReadySet Cloud](../guides/deploy-readyset-cloud.md).
[SSL verification](../guides/deploy-readyset-kubernetes.md#step-4-configure-readyset) | When starting the ReadySet Server and Adapter, you can now tell ReadySet where to find the root certificate for SSL verification using the `--ssl_root_cert` command-line flag or `SSL_ROOT_CERT` environment variable.
[Cache location](../guides/deploy-readyset-kubernetes.md#step-4-configure-readyset) | When starting the ReadySet Server and Adapter, you can now choose to store cached query results on the Adapter rather than on the Server (the default behavior) by passing the `--embedded-readers` flag to the Adapter and the `--no-readers` flag to the Server.
[Table replication scope](../guides/deploy-readyset-kubernetes.md#step-4-configure-readyset) | If the queries you want to cache with ReadySet touch only specific tables, when starting the ReadySet Server, you can now restrict the scope of replication accordingly using the `--replication_tables` command-line flag or `REPLICATION_TABLES` environment variable.
