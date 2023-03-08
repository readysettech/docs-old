# Metrics

The script in this directory can be used to view the query latencies as
reported by ReadySet's Prometheus metrics.

## Running the Script
This script requires Python 3 and pip to be installed as prequisites.

First, install the dependencies:

```bash
pip3 install -r requirements.txt
```

To view latency metrics for all queries, simply run:

```bash
python3 metrics.py
```

To view latency metrics only for queries that appear in ReadySet's
`SHOW PROXIED QUERIES` or `SHOW CACHES` output, pipe the output of the
`SHOW PROXIED QUERIES` or `SHOW CACHES` commands into the script with the
`--filter-queries` flag, updating the database information to match your
configuration:

```bash
PGPASSWORD=noria psql --host=127.0.0.1 --port=5433 --username=postgres --dbname=noria -c "SHOW CACHES" | python3 metrics.py --filter-queries
```
