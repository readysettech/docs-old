---
icon: material/language-python
---

# Connect a Python App to ReadySet

Once you have a ReadySet instance up and running, you connect your application to ReadySet exactly as you would to the upstream database.

This page gives you examples for a few common Postgres drivers and ORMS for Python.

=== "psycopg2"

=== "SQLAlchemy"

## Step 1. Start ReadySet

1. Install and start [Docker Compose](https://docs.docker.com/engine/install/) for your OS.

1. Download our Docker Compose and sample data files and start up Postgres and ReadySet locally:

   ```sh
   curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/{docker-compose-postgres.yml,imdb-postgres.sql}"
   ```

   ```sh
   docker-compose -f docker-compose-postgres.yml up -d
   ```

   This also imports two tables from the [IMDb dataset](https://www.imdb.com/interfaces/) that you'll query from your app.

## Step 2. Get the code

=== "psycopg2"

    1. Create a directory for the code and move into it:

        ``` sh
        mkdir readyset-psycopg2 && cd readyset-psycopg2
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/code/psycopg2/{app.py,requirements.txt}"
        ```

        Or create the following files:

        === ":octicons-file-code-16: `app.py`"

            ``` py
            #!/usr/bin/env python3

            import logging
            import os
            from argparse import ArgumentParser, RawTextHelpFormatter
            import psycopg2

            def query(conn):
                with conn.cursor() as cur:
                    year = 1980
                    cur.execute(
                        """SELECT title_basics.originaltitle, title_ratings.averagerating
                        FROM title_basics
                        JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                        WHERE title_basics.startyear = %s
                        AND title_basics.titletype = %s
                        AND title_ratings.numvotes > %s
                        ORDER BY title_ratings.averagerating DESC LIMIT 10""",
                        (year, 'movie', 50000)
                    )

                    if cur.description is not None:
                        print("")
                        print("Year:", year)
                        rows = cur.fetchall()
                        for row in rows:
                            print([str(cell) for cell in row])

                conn.commit()

            def main():
                opt = parse_cmdline()
                logging.basicConfig(level=logging.DEBUG if opt.verbose else logging.INFO)
                try:
                    db_url = opt.dsn
                    conn = psycopg2.connect(db_url)
                except Exception as e:
                    logging.fatal("database connection failed")
                    logging.fatal(e)
                    return

                query(conn)

                conn.close()

            def parse_cmdline():
                parser = ArgumentParser(description=__doc__,
                                        formatter_class=RawTextHelpFormatter)

                parser.add_argument("-v", "--verbose",
                                    action="store_true", help="print debug info")

                parser.add_argument("dsn",
                                    default=os.environ.get("DATABASE_URL"),
                                    nargs="?",
                                    help="""database connection string
                                    (default: value of the DATABASE_URL env variable)"""
                )

                opt = parser.parse_args()
                if opt.dsn is None:
                    parser.error("database connection string not set")
                return opt

            if __name__ == "__main__":
                main()
            ```

        === ":octicons-file-code-16: `requirements.txt`"

            ``` text
            psycopg2-binary
            ```

=== "SQLAlchemy"

    1. Create a directory for the code and move into it:

        ``` sh
        mkdir readyset-sqlalchemy && cd readyset-sqlalchemy
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/code/sqlalchemy/{main.py,requirements.txt}"
        ```

        Or create the following files:

        === ":octicons-file-code-16: `main.py`"

            ``` py
            import os
            import sqlalchemy as db
            from sqlalchemy.orm import declarative_base
            from sqlalchemy.orm import sessionmaker

            Base = declarative_base()

            engine = db.create_engine(os.environ['DATABASE_URL'])

            class Basic(Base):
                __tablename__ = "title_basics"

                tconst = db.Column(db.TEXT, primary_key=True)
                titletype = db.Column(db.TEXT)
                primarytitle = db.Column(db.TEXT)
                originaltitle = db.Column(db.TEXT)
                isadult = db.Column(db.BOOLEAN)
                startyear = db.Column(db.INTEGER)
                endyear = db.Column(db.INTEGER)
                runtimeminutes = db.Column(db.INTEGER)
                genres = db.Column(db.TEXT)

            class Rating(Base):
                __tablename__ = "title_ratings"

                tconst = db.Column(db.TEXT, primary_key=True)
                averagerating = db.Column(db.NUMERIC)
                numvotes = db.Column(db.INTEGER)

            Session = sessionmaker(bind=engine)
            session = Session()

            year = 1980
            result = session.query(
                Basic.originaltitle, Rating.averagerating). \
                join(Rating, Basic.tconst == Rating.tconst ). \
                filter(Basic.startyear == year). \
                filter(Basic.titletype == 'movie'). \
                filter(Rating.numvotes > 50000). \
                order_by(Rating.averagerating.desc()). \
                limit(10)

            print("Year:", year)

            for r in result:
                print(r.originaltitle, "|", r.averagerating)
            ```

        === ":octicons-file-code-16: `requirements.txt`"

            ``` text
            psycopg2-binary
            sqlalchemy
            ```

## Step 3. Install dependencies

=== "psycopg2"

    1. Install [`virtualenv`](https://virtualenv.pypa.io/en/latest/):

        ``` sh
        pip install virtualenv
        ```

    1. Create and activate a virtual environment:

        ``` sh
        virtualenv env
        ```

        ``` sh
        source env/bin/activate
        ```

    1. Install the required modules to the virtual environment:

        ``` sh
        pip install -r requirements.txt
        ```

=== "SQLAlchemy"

    1. Install [`virtualenv`](https://virtualenv.pypa.io/en/latest/):

        ``` sh
        pip install virtualenv
        ```

    1. Create and activate a virtual environment:

        ``` sh
        virtualenv env
        ```

        ``` sh
        source env/bin/activate
        ```

    1. Install the required modules to the virtual environment:

        ``` sh
        pip install -r requirements.txt
        ```

## Step 4. Connect and query

=== "psycopg2"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres.

            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        python3 app.py
        ```

        The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        Year: 1980
        ['The Empire Strikes Back', '8.7']
        ['The Shining', '8.4']
        ['Raging Bull', '8.2']
        ['The Elephant Man', '8.2']
        ['The Blues Brothers', '7.9']
        ['Airplane!', '7.7']
        ['Ordinary People', '7.7']
        ['The Gods Must Be Crazy', '7.3']
        ['Caddyshack', '7.2']
        ['Superman II', '6.8']
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

=== "SQLAlchemy"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres.

            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        python3 main.py
        ```

        The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        Year: 1980
        The Empire Strikes Back | 8.7
        The Shining | 8.4
        The Elephant Man | 8.2
        Raging Bull | 8.2
        The Blues Brothers | 7.9
        Ordinary People | 7.7
        Airplane! | 7.7
        The Gods Must Be Crazy | 7.3
        Caddyshack | 7.2
        The Fog | 6.8
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

## Next steps

- [Cache queries](/cache/cache-queries.md)

- [Review query support](/reference/sql-support.md)

- [Learn how ReadySet works under the hood](/concepts/overview.md)

- [Deploy with the ReadySet binary](/deploy/deploy-readyset-binary.md)