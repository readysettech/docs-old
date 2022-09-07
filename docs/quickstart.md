# Quickstart

## Start
The ReadySet orchestrator is a command line tool that uses Docker Compose to spin up a ReadySet deployment on your local machine.
Run the following command to download the ReadySet orchestrator.

```sh
bash -c "$(curl -sSL https://launch.readyset.io)"
```

Follow the prompts issued by the orchestrator to configure your ReadySet deployment.
Select a database type (currently, ReadySet supports MySQL and Postgres), set a deployment name and password, and assign ReadySet a port to listen on.
From there, the orchestrator will download the ReadySet Docker images and spin up a new ReadySet instance locally.

## Connect

To connect to ReadySet via the default MySQL or Postgres command line client, run the command that the orchestrator outputs.

 **In the MySQL case:**

```sh
mysql -h127.0.0.1 -uroot -p <password> -P <port> --database=<deployment name>
```

**In the Postgres case:**
```sh
psql postgresql://postgres:<password>@127.0.0.1:<port>/<deployment name>
```

To connect ReadySet to your application, replace your database connection string with the connection string provided by the orchestrator.
See our connection guides [here](/connecting).

## Profile
By default, all queries sent to ReadySet are proxied to the backing database. You can see the current list of proxied queries and
their performance profiles via the ReadySet dashboard which is accessible on `localhost:4000`.
Check out the ReadySet [dashboard docs](/using/dashboard) for
more information about how to interpret the dashboard panels.


## Cache
To cache a query in ReadySet, you’ll need either the query ID (which can be found in the dashboard, or by running `SHOW CACHES`) or the full query text (`SELECT` statement).

From there, you can run `CREATE CACHE FROM <query ID>` or `CREATE CACHE FROM <select statement>`.

ReadySet caches both prepared statements (i.e., parameterized queries) and one-off queries.
