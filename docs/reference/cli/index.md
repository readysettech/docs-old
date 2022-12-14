# ReadySet CLI

A ReadySet deployment sits between your application and database and contains the following core components:

| Component | Purpose |
|-----------|---------|
| ReadySet Server | Takes a snapshot of your database, listens to the database's replication stream for updates, and keeps queries cached in an in-memory dataflow graph. |
| ReadySet Adapter | Handles connections from SQL clients and ORMs, forwards uncached queries to the upstream database, and runs cached queries against the ReadySet Server.

This page introduces the `readyset` commands for running these components, as well as information about environment variables that can be used in place of certain command options.

!!! note

    The ReadySet CLI is relevant only for users running ReadySet themselves. Users on ReadySet Cloud get a fully-managed deployment of ReadySet and do not need to run `readyset` commands.

## Commands

Command | Usage
--------|----
[`readyset`](readyset.md) | <p>Start the ReadySet Server and Adapter as a single process (with the `--standalone` option), or start the ReadySet Adapter as a distinct process from the ReadySet Server.</p>
[`readyset-server`](readyset-server.md) | <p>Start the ReadySet Server, when running the ReadySet Adapter as a distinct process.</p>

## Environment variables

For many common `readyset` and `readyset-server` options, you can set environment variables once instead of manually passing the flags each time you execute commands.

- To find out which flags support environment variables, see the documentation for each [command](#commands).
- To output the current configuration of ReadySet and other environment variables, run `env`.
- When a command uses environment variables, the variable names are printed to the command's logs.

ReadySet prioritizes command flags, environment variables, and defaults as follows:

1. If a flag is set for a command, ReadySet uses it.
2. If a flag is not set for a command, ReadySet uses the corresponding environment variable.
3. If neither the flag nor environment variable is set, ReadySet uses the default for the flag.
4. If there's no flag default, ReadySet returns an error.
