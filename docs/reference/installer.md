# Installer Guide

The ReadySet installer is the fastest way to spin up a working ReadySet instance and connect an existing or new upstream database to it.

As part of the installation process, the installer requires a few configuration options, which are explained below.

### Installer options
- **Deployment name** - a unique name for the ReadySet deployment which can be any string. If a new backing database is created, this is the name of the created database table.
- **Deployment password** - the password to connect to ReadySet. If a new backing database is created, this password is used for the root user also.
- **Deployment port** - the port to connect to ReadySet. The port defaults to 3307 for ReadySet/MySQL and 5433 for ReadySet/Postgres.
- **Backing database address [optional]** - the address that ReadySet will attempt to connect to.
- **Backing database username [optional]** - the username that ReadySet will connect to the database with.
- **Backing database password [optional]** - the password that ReadySet will connect to the database with.
- **Backing database name [optional]** - the database name that ReadySet will connect to.

- **Migration mode (explicit/implicit)** - Explicit migrations mean ReadySet only caches queries you set via the CLI interface. Implicit migration means ReadySet attempts to cache every query that it receives. Implicit migration mode will proxy queries that it cannot support to the underlying database.
- **Experimental query support (enabled/disabled)** - Enables query support for the top-k operator, mixed comparisons, and paginate operations.

*Note: the backing database options are only shown if you choose to use an existing database.*

### Tearing down a deployment
The installer can only be used to manage one local ReadySet cluster at a time. it will allow a user to do one of the following:
1. Start the existing deployment.
2. Upgrade to the latest version of ReadySet for the existing deployment.
3. Wipe the current deployment, including all assets, and begin configuration of a new deployment.
