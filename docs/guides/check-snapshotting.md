# Check Snapshotting

When you first connect ReadySet to your database, ReadySet stores a snapshot of your database tables on disk and then keeps this snapshot up-to-date by listening to your database's replication stream. Queries can be cached in ReadySet only once the tables they access have finished the initial snapshotting process.

Since snapshotting can take between a few minutes to several hours, depending on the size of your dataset, ReadySet gives you a few ways to check the snapshotting status:

- [Check overall status](#use-a-sql-command): You can use a custom SQL command to check the overall snapshotting status of tables.
- [Track detailed progress](#check-log-messages): You can check log messages to track the snapshotting progress and estimated time remaining for each table.



## Check overall status

To check the overall snapshotting status of tables, connect a SQL shell to ReadySet and run the following custom SQL command:

``` sql
SHOW READYSET TABLES;
```

``` {.text .no-copy}
         table            |    status
------------------------------------------
`public`.`title_basics`   | Snapshotting
`public`.`title_ratings`  | Snapshotted
`public`.`title_episodes` | Not Replicated
(3 rows)
```

This command returns a virtual table with 2 columns:

- **Table:** The name of the table in the database that ReadySet is connected to.
- **Status:** The snapshotting status of the table. There are 3 possible statuses:
    - **Snapshotting:** The initial snapshot of the table is in progress.
    - **Snapshotted:** The initial snapshot of the table is complete. ReadySet is replicating changes to the table via the database's replication stream.
    - **Not Replicated:** The table has not been snapshotted by ReadySet. This can be because the table contains [unsupported data types](../reference/sql-support.md#data-types) or has been intentionally excluded from ReadySet replication (via the `--replication-tables` option).

## Track detailed progress

To track the progress and estimated time remaining for each table, `grep` the ReadySet logs for `Snapshotting tables` (Postgres) or `taking database snapshot` (MySQL):

=== "Postgres"

    ``` sh
    cat readyset.log | grep 'Snapshotting table'
    ```

    ``` {.text .no-copy}
    2022-12-13T16:02:48.142605Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "readyset-helm-test"})
    2022-12-13T16:02:48.202895Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting table context=LogContext({"deployment": "readyset-helm-test"})
    2022-12-13T16:02:48.357445Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "readyset-helm-test"}) rows=1246402
    2022-12-13T16:02:48.921839Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting started context=LogContext({"deployment": "readyset-helm-test"}) rows=5159701
    2022-12-13T16:03:11.155418Z  INFO Snapshotting table{table=`public`.`title_ratings`}: replicators::postgres_connector::snapshot: Snapshotting finished context=LogContext({"deployment": "readyset-helm-test"}) rows_replicated=1246402
    2022-12-13T16:03:19.927790Z  INFO Snapshotting table{table=`public`.`title_basics`}: replicators::postgres_connector::snapshot: Snapshotting progress context=LogContext({"deployment": "readyset-helm-test"}) rows_replicated=1126400 progress=21.83% estimate=00:01:51
    ...
    ```

=== "MySQL"

    ``` sh
    cat readyset.log | grep 'taking database snapshot'
    ```

    ```
    2022-10-18T17:18:01.685613Z  INFO taking database snapshot: replicators::noria_adapter: Starting snapshot
    2022-10-18T17:18:01.803163Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Acquiring read lock table=`readyset`.`users`
    2022-10-18T17:18:01.807475Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replicating table table=`readyset`.`users`
    2022-10-18T17:18:01.809739Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Read lock released table=`readyset`.`users`
    2022-10-18T17:18:01.810049Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Acquiring read lock table=`readyset`.`posts`
    2022-10-18T17:18:01.816496Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replicating table table=`readyset`.`posts`
    2022-10-18T17:18:01.818721Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Read lock released table=`readyset`.`posts`
    2022-10-18T17:18:01.822144Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication started rows=4990 table=`readyset`.`users`
    2022-10-18T17:18:01.822376Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication started rows=5000 table=`readyset`.`posts`
    2022-10-18T17:18:01.863220Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication finished rows_replicated=4990 table=`readyset`.`users`
    2022-10-18T17:18:01.864316Z  INFO taking database snapshot:replicating table: replicators::mysql_connector::snapshot: Replication finished rows_replicated=5000 table=`readyset`.`posts`
    2022-10-18T17:18:01.966256Z  INFO taking database snapshot: replicators::noria_adapter: Snapshot finished
    ```
