# Deploy ReadySet with Kubernetes

This page shows you how to run ReadySet with Kubernetes on [Amazon EKS](https://aws.amazon.com/eks/) in front of an Amazon RDS Postgres or MySQL database.

## Before you begin

=== "RDS Postgres"

    - Note that this tutorial covers the [scale-out deployment pattern](production-notes.md#scale-out), with the ReadySet Server and Adapter running as separate processes on separate machines.

    - Make sure you have an [Amazon RDS for Postgres](https://aws.amazon.com/rds/postgresql/) database running Postgres 13 or 14.

        If you want to integrate with another version of Postgres, please [contact ReadySet](mailto:info@readyset.io).

    - Make sure there are no DDL statements in progress.

        ReadySet will take an initial snapshot of your data. Until the entire snapshot is finished, which can take between a few minutes to several hours depending on the size of your dataset, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked.

    - Make sure tables without primary keys have [`REPLICA IDENTITY FULL`](https://www.postgresql.org/docs/current/sql-altertable.html#SQL-ALTERTABLE-REPLICA-IDENTITY).

        If the database you want ReadySet to replicate includes tables without primary keys, make sure you alter those tables with `REPLICA IDENTITY FULL` before connecting ReadySet. Otherwise, Postgres will block writes and deletes on those tables.

    - Make sure [row-level security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) is disabled. ReadySet does not currently support row-level security.

    - Complete the steps described in the [EKS Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) documentation.

        This includes installing and configuring `eksctl`, the command-line tool for creating and deleting Kubernetes clusters on EKS, and `kubectl`, the command-line tool for managing Kubernetes from your workstation.

    - Make sure you meet the [EKS requirements for using an existing VPC](https://eksctl.io/usage/vpc-configuration/#use-existing-vpc-other-custom-configuration).

        For efficient networking and security, you'll deploy your Kubernetes cluster into the same VPC as your database.

=== "RDS MySQL"

    - Note that this tutorial covers the [scale-out deployment pattern](production-notes.md#scale-out), with the ReadySet Server and Adapter running as separate processes on separate machines.

    - Make sure you have an [Amazon RDS for MySQL](https://aws.amazon.com/rds/mysql/) database.

        ReadySet can be run in front of other versions of Postgres and MySQL. However, this tutorial focuses on RDS.

    - Make sure there are no DDL statements in progress.

        ReadySet will take an initial snapshot of your data. Until the entire snapshot is finished, which can take between a few minutes to several hours depending on the size of your dataset, DDL statements (e.g., `ALTER` and `DROP`) against tables in your snapshot will be blocked. `INSERT` and `UPDATE` statements will also be blocked, but only while a given table is being snapshotted.

    - Complete the steps described in the [EKS Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) documentation.

        This includes installing and configuring `eksctl`, the command-line tool for creating and deleting Kubernetes clusters on EKS, and `kubectl`, the command-line tool for managing Kubernetes from your workstation.

    - Make sure you meet the [EKS requirements for using an existing VPC](https://eksctl.io/usage/vpc-configuration/#use-existing-vpc-other-custom-configuration).

        For efficient networking and security, you'll deploy your Kubernetes cluster into the same VPC as your database.

## Deploying with Helm
   The ReadySet Helm chart is under active development. For the latest instructions on how to deploy ReadySet with Helm, see the [documentation here](https://github.com/readysettech/readyset/blob/main/helm/readyset/README.md).

## Next steps

- Cache queries

    Once you've identified queries to cache, use ReadySet's [custom SQL commands](../cache/cache-queries.md) to check if ReadySet supports them and then cache them in ReadySet.

    !!! note

        To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query. For more details, see [SQL Support](../reference/sql-support/#query-caching). If an unsupported feature is important to your use case, [submit a feature request](https://github.com/readysettech/readyset/issues/new/choose).
