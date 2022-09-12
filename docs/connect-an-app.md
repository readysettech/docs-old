# Connecting to ReadySet

Once you have a ReadySet instance up and running, the next step is to connect your application. The easiest way to get up and
running is to swap out your database connection string to point to ReadySet instead. The specifics of how to do this vary by
database client library, ORM, and programming language. Below are a few examples.

## Python

=== "MySQL"

    === "SQLAlchemy"

        ```python
        from sqlalchemy import create_engine
        import os

        engine = create_engine(os.environ['DATABASE_URL'])
        engine.connect()
        ```

        where `DATABASE_URL` is an environment variable with the following format:

        ```sh
        mysql://{username}:{password}@{host}:{port}/{database}?sslmode=verify-full&sslrootcert={root-cert}
        ```
    === "Django"

        To connect to ReadySet from a Django application, modify the DATABASES property in the settings.py file. Per the Django documentation, ensure that you have mysqlclient or another db api driver installed.

        ```python
        DATABASES = {
            'default': {
                'ENGINE': 'django.db.backends.mysql',
                'NAME': '{database}',
                'USER': '{username}',
                'PASSWORD': '{password}',
                'HOST': '{host}',
                'PORT': '{port}'
            }
        }

        ```

        You can read the official documentation about connecting Django to a MySQL database [here](https://docs.djangoproject.com/en/4.0/ref/databases/#connecting-to-the-database).

=== "Postgres"

    === "Pyscopg2"

        To connect with Psycopyg2, pass a database URL to the psycopg2.connect function:

        ```python
        import psycopg2
        import os

        connection = psycopg2.connect(os.environ['DATABASE_URL'])
        ```

        In this case, `DATABASE_URL` is an environment variable with the following format:

        ```sh
        postgresql://{username}:{password}@{host}:{port}/{database}?sslmode=verify-full&sslrootcert={root-cert}
        ```

    === "SQLAlchemy"

        ```python
        from sqlalchemy import create_engine
        import os

        engine = create_engine(os.environ['DATABASE_URL'])
        engine.connect()
        ```

        where `DATABASE_URL` is an environment variable with the following format:

        ```sh
        mysql://{username}:{password}@{host}:{port}/{database}?sslmode=verify-full&sslrootcert={root-cert}
        ```

    === "Django"

        To connect to ReadySet from a Django application, modify the DATABASES property in the settings.py file. Per the Django documentation, pyscopg2 is required.

        ```python
        DATABASES = {
            'default': {
                'ENGINE': 'django.db.backends.postgresql',
                'NAME': '{database}',
                'USER': '{username}',
                'PASSWORD': '{password}',
                'HOST': '{host}',
                'PORT': '{port}'
            }
        }

        ```

## Javascript

=== "MySQL"

    === "Sequelize"

        To connect to ReadySet, first create a Sequelize object and pass it the correct parameters. According to the official documentation, there are several ways to do this.

        ```js
        const Sequelize = require("sequelize");

        const connectionString = "{dialect}://{username}:{password}@{host}:{port}/{database}"
        const sequelize = new Sequelize(connectionString)
        ```

        or

        ```js
        const Sequelize = require("sequelize");

        const sequelize = new Sequelize('database', 'username', 'password', {
          host: 'localhost',
          dialect: /* one of 'mysql' | 'mariadb' | 'postgres' | 'mssql' */
        });
        ```

        There are several ways to correctly pass database connection parameters to Sequelize. To read more about them, see the official documentation [here](https://sequelize.org/).

    === "TypeORM"

        To get started using TypeORM and ReadySet, follow the steps below.

        1) Install TypeORM:

        ```javascript
            npm install typeorm --save
        ```

        2) Install dependencies, including the correct database driver. A full list of supported drivers is listed [here](https://typeorm.io/#installation).

        ```js
        npm install reflect-metadata --save
        npm install (database-driver)
        ```

        3) Configure your datasource in TypeORM’s `data-source.ts` file:

        ```js
        export const AppDataSource = new DataSource({
            type: "{databasetype}",
            host: "{host}",
            Port: {port},
            username: "{username}",
            password: "{password}",
            database: "{database-name}",
            synchronize: false,
            logging: true,
            entities: [], // entities to keep track of
            subscribers: [],
            migrations: [],
        })
        ```

        For more information, read the official TypeORM documentation [here](https://typeorm.io/).

=== "Postgres"

    === "Sequelize"

        To connect to ReadySet, first create a Sequelize object and pass it the correct parameters. According to the official documentation, there are several ways to do this.

        ```js
        const Sequelize = require("sequelize");

        const connectionString = "{dialect}://{username}:{password}@{host}:{port}/{database}"
        const sequelize = new Sequelize(connectionString)
        ```

        or

        ```js
        const Sequelize = require("sequelize");

        const sequelize = new Sequelize('database', 'username', 'password', {
          host: 'localhost',
          dialect: /* one of 'mysql' | 'mariadb' | 'postgres' | 'mssql' */
        });
        ```

        There are several ways to correctly pass database connection parameters to Sequelize. To read more about them, see the official documentation [here](https://sequelize.org/).

    === "TypeORM"

        To get started using TypeORM and ReadySet, follow the steps below.

        1) Install TypeORM:

        ```javascript
            npm install typeorm --save
        ```

        2) Install dependencies, including the correct database driver. A full list of supported drivers is listed [here](https://typeorm.io/#installation).

        ```js
        npm install reflect-metadata --save
        npm install (database-driver)
        ```

        3) Configure your datasource in TypeORM’s `data-source.ts` file:

        ```js
        export const AppDataSource = new DataSource({
            type: "{databasetype}",
            host: "{host}",
            Port: {port},
            username: "{username}",
            password: "{password}",
            database: "{database-name}",
            synchronize: false,
            logging: true,
            entities: [], // entities to keep track of
            subscribers: [],
            migrations: [],
        })
        ```

        For more information, read the official TypeORM documentation [here](https://typeorm.io/).
