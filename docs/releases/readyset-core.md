# ReadySet Core Releases

ReadySet releases a new version of ReadySet Core on a weekly basis. This page summarizes the changes in each version and links to binaries and docker images.

!!! warning

    Beta versions of ReadySet are backward-incompatible. To upgrade between beta versions, you must therefore clear all data files. Rolling upgrades will be supported with future ReadySet major releases.

## beta-2022-11-09

### Downloads

=== ":material-linux: Linux"

    !!! note

        ReadySet binaries for Linux require the OpenSSL 1.1.x package. OpenSSL 3.x+ is not currently supported.

    Binary (linux-x84_64) | Sha256Sum
    ------------------------------|----------
    [ReadySet Server](https://github.com/readysettech/readyset/files/9974540/readyset-server-beta-2022-11-09.linux-x86_64.tar.gz) | d52631fb7b8b0a912aa205f005ffd32b8494f38fb43ea96ccee08b41c216002d
    [ReadySet Adapter for MySQL](https://github.com/readysettech/readyset/files/9974536/readyset-mysql-beta-2022-11-09.linux-x86_64.tar.gz) | 966f4701beca80faf8d572fd261ff8431bbda374557680c2687e452c6cc228d6`
    [ReadySet Adapter for Postgres](https://github.com/readysettech/readyset/files/9974538/readyset-psql-beta-2022-11-09.linux-x86_64.tar.gz) | 6a1a5a47b3ee138c38d1d493fe5d442dabd001abb4858982dc2dfba3fbd6eaaf

=== ":material-apple: Mac"

    Binary (darwin-arm64) | Sha256Sum
    ------------------------------|----------
    [ReadySet Server](https://github.com/readysettech/readyset/files/9974631/readyset-server-beta-2022-11-09.darwin-arm64.tar.gz) | 76d7a65b9ef953af5ea337fa7ed731524c463d961835f7cb80444c6c9cc7a7d3
    [ReadySet Adapter for MySQL](https://github.com/readysettech/readyset/files/9974630/readyset-mysql-beta-2022-11-09.darwin-arm64.tar.gz) | 0c00931f87900e5570cdb83421ceddba64e55abe5316e0f29bd59848849f7884
    [ReadySet Adapter for Postgres](https://github.com/readysettech/readyset/files/9974629/readyset-psql-beta-2022-11-09.darwin-arm64.tar.gz) | 81faacc0e463f5dbe3b1a0fa5d139ea86e203f36e39d91814cfc1fc391c52d10

=== ":material-docker: Docker"

    - ReadySet Server (linux-x84_64)
        ``` sh
        docker pull public.ecr.aws/readyset/readyset-server:beta-2022-11-09
        ```

    - ReadySet Adapter (linux-x84_64)
        ``` sh
        docker pull public.ecr.aws/readyset/readyset-adapter:beta-2022-11-09
        ```

### Changes

- Added replication and caching support for Postgres enumerated data types. [d8e428d](https://github.com/readysettech/readyset/commit/d8e428d5cf63fc704d2b9242066c2bccafffd76b), [e282ae9](https://github.com/readysettech/readyset/commit/e282ae99fe0f7e2491f56203b455b9f2e72ebd8e), [40d217f](https://github.com/readysettech/readyset/commit/40d217fdb8b55f004a8e3cbca9d2e30b379bd269), [ef95276](https://github.com/readysettech/readyset/commit/ef95276d4c3498ce77eed81e2d2d2185c0b21791), [5b401a5](https://github.com/readysettech/readyset/commit/5b401a5ecd805bba26421eaaf1a5f42ce5bd7dcd), [23e6a12](https://github.com/readysettech/readyset/commit/23e6a120ac3090cdd9cdf408824b24973ebc80d6), [312dfa0](https://github.com/readysettech/readyset/commit/312dfa04574cd7d471d5b35598c92df13d496168), [2fe679f](https://github.com/readysettech/readyset/commit/2fe679f20348a74e7e07ce2517073348ce365c11), [2295188](https://github.com/readysettech/readyset/commit/2295188268b744e630ef5f6adbf03c0fd3e3e68a)
- Added caching support for the `?|` and `?&` JSON operators. [f5ae4d](https://github.com/readysettech/readyset/commit/f5ae4d0c004dfe9095523155cf0ceb78fe14309b), [6598431](https://github.com/readysettech/readyset/commit/659843199836c321ed4fecbce31c894dd2100fa2)
- Fixed a bug that would cause `CREATE CACHE` commands to fail for MySQL `JOIN` queries with join conditions in the `WHERE` clause instead of the `ON` clause. [f9be6d6](https://github.com/readysettech/readyset/commit/f9be6d6e99c284f2a30163075a272063bab2f449)
- Upgraded OpenSSL to address a recently identified [vulnerability](https://github.com/advisories/GHSA-8rwr-x37p-mx23). [4525073](https://github.com/readysettech/readyset/commit/4525073eb2a505ef0ef2489f79a0149cf6a29fcd)
- ReadySet now logs the names of table/views that fail to snapshot or replicate. [7ffaf07](https://github.com/readysettech/readyset/commit/7ffaf07cbfca81691760b3ebf0b53afc66ac85e0)
- ReadySet now logs queries that fail to parse. [a25c401](https://github.com/readysettech/readyset/commit/a25c401b450a7a919cb380e13aa14a089be7333f)
- Added node column types to Graphviz data flow visualizations. [30f023b](https://github.com/readysettech/readyset/commit/30f023bf41c9c6a0548b83f71e76c35ee7f336a0)
- The ReadySet Adapter now fails to start and returns and error when its version does not match the ReadySet Server. [e00c742](https://github.com/readysettech/readyset/commit/e00c742bdee9dd7c23361cade496fee1402ecaa3)

## beta-2022-11-01

### Downloads

=== ":material-linux: Linux"

    !!! note

        ReadySet binaries for Linux require the OpenSSL 1.1.x package. OpenSSL 3.x+ is not currently supported.

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
