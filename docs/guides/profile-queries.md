# Profile Queries

While running ReadySet, you can view that instance's metrics. Metrics are emitted for freed memory, packets sent, per-query metrics including latencies, and more.

!!! note
    To view metrics, the `--prometheus-metrics` flag must be enabled. To view per-query metrics, the `--query-log` and `--query-log-ad-hoc` flags must be passed.


## Viewing Metrics

Metrics are aggregated and available on port `6034` at the `/metrics` endpoint. If running ReadySet locally, navigate to `https://localhost:6034/metrics` in your browser.

## Examining per-query metrics

We have a metrics utility script written in Python that queries this metrics endpoint and displays latencies for queries received by ReadySet.

To run the script, follow these steps.

1. Install dependencies by running `pip3 install urllib3 tabulate`.

2. Run the script with 

```
curl -O https://raw.githubusercontent.com/readysettech/docs/main/docs/assets/metrics.py \
&& python3 metrics.py
```

NOTE: If you're running ReadySet in Docker, ensure that port 6034 is exposed.