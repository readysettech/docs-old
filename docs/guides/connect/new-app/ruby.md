---
icon: material/language-ruby
---

# Connect a Ruby App to ReadySet

Once you have a ReadySet instance up and running, you connect your application to ReadySet exactly as you would to the upstream database.

This page gives you examples for a few common Postgres drivers and ORMS for Ruby.

=== "pg"

=== "ActiveRecord"

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

=== "pg"

    1. Create a directory for the code and move into it:

        ``` sh
        mkdir readyset-pgx && cd readyset-pgx
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/ruby-pg/{main.rb,Gemfile}"
        ```

        Or create the following files:

        === "`main.rb`"

            ``` ruby
            #!ruby

            require 'pg'

            def query(conn)
                puts '------------------------------------------------'

                year = 1980
                puts 'Year: %d' % [year]

                res = conn.exec('SELECT title_basics.originaltitle, title_ratings.averagerating
                                FROM title_basics
                                JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                                WHERE title_basics.startyear = $1
                                AND title_basics.titletype = $2
                                AND title_ratings.numvotes > $3
                                ORDER BY title_ratings.averagerating DESC LIMIT 10',
                                [year, 'movie', 50000])

                res.each do |val|
                    puts val
                end
            end

            def main()
                conn = PG.connect(ENV['DATABASE_URL'])

                query(conn)

                conn.close()
            end

            main()
            ```

        === "`Gemfile`"

            ``` ruby
            source "https://rubygems.org"

            gem "pg"
            ```

=== "ActiveRecord"

    1. Create a directory for the code and move into it:

        ``` sh
        mkdir readyset-activerecord && cd readyset-activerecord
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/activerecord/{main.rb,Gemfile}"
        ```

        Or create the following files:

        === "`main.rb`"

            ``` ruby
            require 'pg'
            require 'active_record'

            ActiveRecord::Base.establish_connection(
                adapter: 'postgresql',
                url: ENV['DATABASE_URL']
            )

            class Basic < ActiveRecord::Base
                self.table_name = 'title_basics'
                self.primary_key = 'tconst'
            end

            class Rating < ActiveRecord::Base
                self.table_name = 'title_ratings'
                self.primary_key = 'tconst'
            end

            year = 1980
            puts 'Year: %d' % [year]

            Basic.find_by_sql(['SELECT title_basics.originaltitle, title_ratings.averagerating
                FROM title_basics
                JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                WHERE title_basics.startyear = ?
                AND title_basics.titletype = ?
                AND title_ratings.numvotes > ?
                ORDER BY title_ratings.averagerating DESC LIMIT 10',
                year, 'movie', 50000]).
                each { |r| puts "#{r.originaltitle},  #{r.averagerating}" }
            ```

        === "`Gemfile`"

            ``` ruby
            source "https://rubygems.org"

            gem "pg"
            gem 'activerecord', '~>7.0.3'
            ```

## Step 3. Install dependencies

=== "pg"

    1. Install `libpq` for your platform.

        For example, to install libpq on macOS with Homebrew, run the following command:

        ``` sh
        brew install libpq
        ```

    1. Configure `bundle` to use `libpq`.

        For example, if you installed `libpq` on macOS with Homebrew, run the following command:

        ``` sh
        bundle config --local build.pg --with-opt-dir="{libpq-path}"
        ```

        where `{libpq-path}` is the full path to the `libpq` installation on your machine (e.g., `/usr/local/opt/libpq`).


    1. Install the dependencies:

        ``` sh
        bundle install
        ```

=== "ActiveRecord"

    1. Install `libpq` for your platform.

        For example, to install libpq on macOS with Homebrew, run the following command:

        ``` sh
        brew install libpq
        ```

    1. Configure `bundle` to use `libpq`.

        For example, if you installed `libpq` on macOS with Homebrew, run the following command:

        ``` sh
        bundle config --local build.pg --with-opt-dir="{libpq-path}"
        ```

        where `{libpq-path}` is the full path to the `libpq` installation on your machine (e.g., `/usr/local/opt/libpq`).


    1. Install the dependencies:

        ``` sh
        bundle install
        ```

## Step 4. Connect and query

=== "pg"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres.

            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        ruby main.rb
        ```

         The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        ------------------------------------------------
        Year: 1980
        {"originaltitle"=>"The Empire Strikes Back", "averagerating"=>"8.7"}
        {"originaltitle"=>"The Shining", "averagerating"=>"8.4"}
        {"originaltitle"=>"Raging Bull", "averagerating"=>"8.2"}
        {"originaltitle"=>"The Elephant Man", "averagerating"=>"8.2"}
        {"originaltitle"=>"The Blues Brothers", "averagerating"=>"7.9"}
        {"originaltitle"=>"Airplane!", "averagerating"=>"7.7"}
        {"originaltitle"=>"Ordinary People", "averagerating"=>"7.7"}
        {"originaltitle"=>"The Gods Must Be Crazy", "averagerating"=>"7.3"}
        {"originaltitle"=>"Caddyshack", "averagerating"=>"7.2"}
        {"originaltitle"=>"Superman II", "averagerating"=>"6.8"}
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

=== "ActiveRecord"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres.

            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        ruby main.rb
        ```

         The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        Year: 1980
        The Empire Strikes Back,  8.7
        The Shining,  8.4
        The Elephant Man,  8.2
        Raging Bull,  8.2
        The Blues Brothers,  7.9
        Ordinary People,  7.7
        Airplane!,  7.7
        The Gods Must Be Crazy,  7.3
        Caddyshack,  7.2
        The Fog,  6.8
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

## Next steps

- [Cache queries](/guides/cache/cache-queries)

- [Review query support](/reference/sql-support)

- [Learn how ReadySet works under the hood](/concepts/overview)

- [Deploy with ReadySet Cloud](/guides/deploy/deploy-readyset-cloud)
