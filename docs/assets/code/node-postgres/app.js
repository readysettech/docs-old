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
