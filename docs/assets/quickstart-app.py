#!/usr/bin/env python3

import argparse
import psycopg2
import time

parser = argparse.ArgumentParser(
    description="test performance of ReadySet vs. a backing Postgres database")
parser.add_argument("--query",
                    required=True,
                    help="query to execute")
parser.add_argument("--repeat",
                    type=int,
                    help="number of times to run the query",
                    default = 20)
parser.add_argument("--url",
                    required=True,
                    help="connection URL for ReadySet or Postgres")
args = parser.parse_args()

conn = psycopg2.connect(dsn=args.url)
conn.set_session(autocommit=True)
cur = conn.cursor()

def calculate_median_latency(lst):
    n = len(lst)
    if n < 1:
        return None
    if n % 2 == 1:
        return sorted(lst)[n//2]
    else:
        return sum(sorted(lst)[n//2-1:n//2+1])/2.0

times = list()
for n in range(args.repeat):
    start = time.time()
    query = args.query
    cur.execute(query)
    if n < 1:
        if cur.description is not None:
            colnames = [desc[0] for desc in cur.description]
            print("")
            print("Result:")
            print(colnames)
            rows = cur.fetchall()
            for row in rows:
                print([str(cell) for cell in row])
    end = time.time()
    times.append((end - start)* 1000)

cur.close()
conn.close()

print("")
print("Query latencies (in milliseconds):")
print(times)
print("")

print("Median query latency (in milliseconds):")
print(calculate_median_latency(times))
print("")
