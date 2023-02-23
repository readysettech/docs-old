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
