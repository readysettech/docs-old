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
