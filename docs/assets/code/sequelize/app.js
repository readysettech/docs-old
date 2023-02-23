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
