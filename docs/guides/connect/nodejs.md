---
icon: material/nodejs
---

# Connect a Node.js App to ReadySet

Once you have a ReadySet instance up and running, you connect your application to ReadySet exactly as you would to the upstream database. 

This page gives you examples for a few common Postgres drivers and ORMS for Node.js.

=== "node-postgres"

=== "Sequelize"

## Step 1. Start ReadySet

1. Install and start [Docker Compose](https://docs.docker.com/engine/install/) for your OS.

1. Download our Docker Compose and sample data files and start up Postgres and ReadySet locally:

    ``` sh
    curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/{docker-compose-postgres.yml,imdb-postgres.sql}"
    ```

    ``` sh
    docker-compose -f docker-compose-postgres.yml up -d
    ```

    This also imports two tables from the [IMDb dataset](https://www.imdb.com/interfaces/) that you'll query from your app.

## Step 2. Get the code

=== "node-postgres"

    1. Create a directory for the code and move into it:

        ``` sh 
        mkdir readyset-node-postgres && cd readyset-node-postgres
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/code/node-postgres/{app.js,package.json}"
        ```

        Or create the following files:

        === ":octicons-file-code-16: `app.js`"

            ``` js 
            const { Pool } = require('pg')

            const connectionString = process.env.DATABASE_URL;

            const pool = new Pool({
                connectionString,
            });

            async function query(year) {
                const text = 
                        `SELECT title_basics.originaltitle, title_ratings.averagerating
                        FROM title_basics
                        JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                        WHERE title_basics.startyear = $1
                        AND title_basics.titletype = $2
                        AND title_ratings.numvotes > $3
                        ORDER BY title_ratings.averagerating DESC LIMIT 10`;
                const values = [year, 'movie', 50000] 

                await pool.query(text, values, (err, res) => {
                    if (err) {
                        console.log(err.stack)
                    } else {
                        console.log("Year:", year);
                        console.log(res.rows)
                    }
                })
            }

            let year = 1980
            query(year)
            ```

        === ":octicons-file-code-16: `package.json`"

            ``` json
            {
                "dependencies": {
                    "child-process": "latest",
                    "pg": "latest",
                    "pg-connection-string": "latest",
                    "prompt": "latest"
                }
            }
            ```

=== "Sequelize"

    1. Create a directory for the code and move into it:

        ``` sh 
        mkdir readyset-sequelize && cd readyset-sequelize
        ```

    1. Download the sample code:

        ``` sh
        curl -O "https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/code/sequelize/app.js"
        ```

        Or create the following file:

        ``` js title="app.js"
        const { Sequelize, Model, DataTypes, QueryTypes} = require('sequelize');
        const sequelize = new Sequelize(process.env.DATABASE_URL)

        const Basic = sequelize.define('Basic', {
            tconst: {type: DataTypes.STRING, primaryKey: true},
            titleType: {type: DataTypes.STRING},
            primaryTitle: {type: DataTypes.STRING},
            originalTitle: {type: DataTypes.STRING},
            isAdult: {type: DataTypes.BOOLEAN},
            startYear: {type: DataTypes.INTEGER},
            endYear: {type: DataTypes.INTEGER},
            runTimeMinutes: {type: DataTypes.INTEGER},
            genres: {type: DataTypes.STRING} 
        }, {tableName: 'title_basics'});

        const Rating = sequelize.define('Rating', {
            tconst: {type: DataTypes.STRING, primaryKey: true},
            averageRating: {type: DataTypes.FLOAT},
            numVotes: {type: DataTypes.INTEGER}, 
        }, {tableName: 'title_ratings'});

        async function query(year) {
            const results = await sequelize.query(
                `SELECT title_basics.originaltitle, title_ratings.averagerating
                FROM title_basics
                JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                WHERE title_basics.startyear = ?
                AND title_basics.titletype = ?
                AND title_ratings.numvotes > ?
                ORDER BY title_ratings.averagerating DESC LIMIT 10`,
                {
                    replacements: [year, 'movie', 50000],
                    type: sequelize.QueryTypes.SELECT,
                    logging: false
                }
            );
            console.log("Year:", year);
            console.log(results)
        }

        let year = 1980
        query(year)
        ```

## Step 3. Install dependencies

=== "node-postgres"


    Install the app requirements, including the [node-postgres](https://node-postgres.com/) driver:

    ``` sh
    npm install
    ```

=== "Sequelize"

    Install [Sequelize](https://sequelize.org/) and the [node-postgres](https://node-postgres.com/) driver:

    ``` sh 
    npm install --save sequelize
    ```

    ``` sh 
    npm install --save pg pg-hstore
    ```

## Step 4. Connect and query

=== "node-postgres"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres. 
            
            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        node app.js
        ```

         The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        Year: 1980
        [
          { originaltitle: 'The Empire Strikes Back', averagerating: '8.7' },
          { originaltitle: 'The Shining', averagerating: '8.4' },
          { originaltitle: 'Raging Bull', averagerating: '8.2' },
          { originaltitle: 'The Elephant Man', averagerating: '8.2' },
          { originaltitle: 'The Blues Brothers', averagerating: '7.9' },
          { originaltitle: 'Ordinary People', averagerating: '7.7' },
          { originaltitle: 'Airplane!', averagerating: '7.7' },
          { originaltitle: 'The Gods Must Be Crazy', averagerating: '7.3' },
          { originaltitle: 'Caddyshack', averagerating: '7.2' },
          { originaltitle: 'The Fog', averagerating: '6.8' }
        ]        
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

=== "Sequelize"

    1. Set the `DATABASE_URL` environment variable to the connection string for ReadySet:

        ``` sh
        export DATABASE_URL="postgresql://postgres:readyset@127.0.0.1:5433/imdb?sslmode=disable"
        ```

        !!! note

            ReadySet takes the same standard-format connection string as Postgres. 
            
            In this case, since both ReadySet and Postgres are running locally, only the port portion is different (`5433` for ReadySet, `5432` for Postgres).

    1. Run the code:

        ``` sh
        node app.js
        ```

         The code connects to ReadySet and then executes a query that joins results from two tables to get the title and average rating of the 10 top-rated movies with over 50,000 votes from 1980.

        ``` {.text .no-copy}
        Year: 1980
        [
          { originaltitle: 'The Empire Strikes Back', averagerating: '8.7' },
          { originaltitle: 'The Shining', averagerating: '8.4' },
          { originaltitle: 'Raging Bull', averagerating: '8.2' },
          { originaltitle: 'The Elephant Man', averagerating: '8.2' },
          { originaltitle: 'The Blues Brothers', averagerating: '7.9' },
          { originaltitle: 'Ordinary People', averagerating: '7.7' },
          { originaltitle: 'Airplane!', averagerating: '7.7' },
          { originaltitle: 'The Gods Must Be Crazy', averagerating: '7.3' },
          { originaltitle: 'Caddyshack', averagerating: '7.2' },
          { originaltitle: 'The Fog', averagerating: '6.8' }
        ]        
        ```

        !!! note

            Since the query has not been cached in ReadySet, ReadySet proxies the query and returns the results from Postgres. After the query is cached, ReadySet returns the results directly and blazing fast!

## Next steps

- [Cache queries](../cache/cache-queries.md)

- [Review query support](../../reference/sql-support.md)

- [Learn how ReadySet works under the hood](../../concepts/overview.md)

- [Deploy with ReadySet Cloud](../deploy/deploy-readyset-cloud.md)
