# Connect an Existing App to ReadySet

Once you have a ReadySet instance up and running, connecting your application to ReadySet works exactly the same as connecting to your existing database.

This usually involves changing your database connection string, either via an ORM setting or an environment variable.

If you've followed the [ReadySet quick start]('../../intro/quickstart.md'), your connection string will be:

```sh
postgres://postgres:readyset@127.0.0.1:5433/imdb
```

If you've deployed the [ReadySet binary]('../../deploy/deploy-readyset-binary'), use the host, port, username and password you started the server with.

=== "Prisma"

    Change the `DATABASE_URL` variable in your `schema.prisma` file to point to ReadySet's connection string.

    ```json
    datasource db {
      provider = "postgresql"
      url      = \<readyset connection string\>
    }
    ```

    Alternatively, set the `DATABASE_URL` environment variable to the ReadySet connection string.

    ```sh
    export DATABASE_URL=<readyset connection string>
    ```

=== "Sequelize"

    Modify the Sequelize constructor, passing in ReadySet's connection string.

    ```js
    const sequelize = new Sequelize(<ReadySet connection string>)
    ```

=== "ActiveRecord (Rails)"

    Modify the config/database.yml file, leaving the adapter the same and pointing the connection string at ReadySet.

    ```yml
    development:
      adapter: postgresql
      url: <readyset connection string>
    ```

    Alternatively, set  the `DATABASE_URL` environment variable to the ReadySet connection string.

    ```sh
    export DATABASE_URL=<readyset connection string>
    ```

=== "Django"

    Change the database connection string in `settings.py`.

    ```python
    DATABASES = {
      "default": {
          "ENGINE": "django.db.backends.postgresql",
          "USER": <ReadySet username>,
          "PASSWORD": <ReadySet password>,
          "HOST": <ReadySet hostname>,
          "PORT": <ReadySet port>,
      }
    }
    ```

=== "SQLAlchemy"

    Modify the `create_engine` constructor, passing in ReadySet's connection string.

    ```python
    from sqlalchemy import create_engine
    engine = create_engine("postgresql+psycopg2://<readyset connection string>")
    ```

=== "Others"

Any tool that supports the MySQL or Postgres wire protocol works with ReadySet.

Change your database connection string to point at the ReadySet instance.
