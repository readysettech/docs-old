---
icon: material/language-go
---

# Connect a Go App to ReadySet

Once you have a ReadySet instance up and running, you connect your application to ReadySet exactly as you would to the upstream database.

This page gives you an example for the Go [pgx](https://github.com/jackc/pgx) driver.

=== "pgx"

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

=== "pgx"

    1. Create a directory for the code and move into it:

        ``` sh
        mkdir readyset-pgx && cd readyset-pgx
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/code/pgx/main.go"
        ```

        Or create the following file yourself:

        ``` go title="main.go"
        package main

        import (
            "context"
            "log"
            "os"

            "github.com/jackc/pgx/v5"
        )

        func main() {

            ctx := context.Background()
            connStr := os.Getenv("DATABASE_URL")
            log.SetFlags(0)

            conn, err := pgx.Connect(ctx, connStr)
            if err != nil {
                log.Fatal(err)
            }
            defer conn.Close(ctx)

            var (
                year int = 1980
                title string
                rating float32
            )
            rows, err := conn.Query(ctx,
                `SELECT title_basics.originaltitle, title_ratings.averagerating
                FROM title_basics
                JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                WHERE title_basics.startyear = $1
                AND title_basics.titletype = $2
                AND title_ratings.numvotes > $3
                ORDER BY title_ratings.averagerating DESC LIMIT 10`,
                year, "movie", 50000)
            if err != nil {
                log.Fatal(err)
            }
            defer rows.Close()

            log.Println("Year:", year)
            for rows.Next() {
                err := rows.Scan(&title, &rating)
                if err != nil {
                    log.Fatal(err)
                }
                log.Println(title, rating)
            }
            err = rows.Err()
            if err != nil {
                log.Fatal(err)
            }
        }
        ```

## Step 3. Install dependencies

=== "pgx"

    Initialize the module:

    ``` sh
    go mod init basic-sample && go mod tidy
    ```

## Step 4. Connect and query

=== "pgx"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres.

            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        go run main.go
        ```

         The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        Year: 1980
        The Empire Strikes Back 8.7
        The Shining 8.4
        Raging Bull 8.2
        The Elephant Man 8.2
        The Blues Brothers 7.9
        Airplane! 7.7
        Ordinary People 7.7
        The Gods Must Be Crazy 7.3
        Caddyshack 7.2
        Superman II 6.8
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

## Next steps

- [Cache queries](../../cache/cache-queries.md)

- [Review query support](../../../reference/sql-support.md)

- [Learn how ReadySet works under the hood](../../../concepts/overview.md)

- [Deploy with ReadySet Cloud](../../deploy/deploy-readyset-cloud.md)
