# Deploy with ReadySet Cloud

This page explains the process for getting up and running with a fully-managed deployment of ReadySet.

## Step 1. Get early access

ReadySet Cloud is currently in closed beta.  

[Get early access to ReadySet Cloud](https://readysettech.typeform.com/to/BqovNk8A?typeform-source=readyset.io){ .md-button }

## Step 2. Discuss your use case

Once you sign up for early access, we will schedule time to discuss your use case and determine if it's a good fit.

Generally, ReadySet Cloud is a good fit for read-heavy applications with a backing MySQL or Postgres database on AWS.

## Step 3. Provide required details

We'll then ask you to provide details about your database and application workload so that we can plan a ReadySet Cloud deployment to meet your needs.

**Database deployment**

- What AWS MySQL or Postgres deployment do you use (e.g., RDS, Aurora, self-deployed)?
- What version of MySQL or Postgres are you running (e.g., MySQL 8, PostgreSQL 14)?
- What AWS region is your database running in (e.g., us-east-1, eu-central-1)?

**Database access**

- What database connection string should ReadySet use to integrate with the database?
- Is your database running in a private or public network?
- If private, what is the VPC ID, IPv4 CIDR, and subnets?

**Database size**

- What is the overall size of your database?
- Which tables are accessed by queries that you want ReadySet to cache?
- For each table, what is the overall data size and how many rows and columns does it contain?

**Workload characteristics**

- On average, how many reads per second do you want ReadySet to serve?
- On average, how many simultaneous connections do you expect?

## Step 4. Configure your database

Once we have the required information, we will guide you to configure your database so that ReadySet can integrate and consume your database's replication stream, which ReadySet uses to keep its cache up-to-date as the database changes. This will involve:

- Giving ReadySet access to your database network
- Making sure that your database's replication stream is enabled ([logical replication](https://www.postgresql.org/docs/current/logical-replication.html) in Postgres, the [binary log](https://dev.mysql.com/doc/refman/5.7/en/binary-log.html) in MySQL)

## Step 5. Set up ReadySet

We'll then:

- Provision the hardware for your ReadySet deployment.
- Verify that we can connect to your network and database.
- Start your ReadySet deployment.

Your ReadySet deployment will take an initial snapshot of your data, which can take between a few minutes to several hours depending on the size of your dataset.

## Step 6. Use ReadySet

Once snapshotting is finished, we'll give you the details you need to start caching queries with ReadySet, including:

- The username, password, and endpoint for your ReadySet deployment so you can change your application's connection string to point at ReadySet instead of at the backing database
- A link to a [Grafana dashboard](../reference/dashboard.md) where you can profile the latencies of queries sent through ReadySet and identify queries to cache
