# Metrics

The script in this directory can be used to view the query latencies as
reported by ReadySet's Prometheus metrics.

## Running the Script
This script requires Python 3 and pip to be installed as prequisites.

First, install the dependencies:

```bash
pip3 install -r requirements.txt
```

To run the script, pipe the output of ReadySet's `SHOW PROXIED QUERIES` or
`SHOW CACHES` commands like so, updating the database information to match your
configuration:

```bash
PGPASSWORD=noria psql --host=127.0.0.1 --port=5433 --username=postgres --dbname=noria -c "SHOW CACHES" | python3 metrics.py
```

The script will display latency metrics for only the queries that are present
in the `SHOW PROXIED QUERIES`/`SHOW CACHES` output that was piped into the
script.
