##!/usr/bin/env python3
import argparse
import urllib3
from tabulate import tabulate, SEPARATING_LINE

parser = argparse.ArgumentParser(
    description="print out formatted ReadySet query statistics from the metrics endpoint")
parser.add_argument("--host",
                    help="host for running ReadySet instance",
					default="localhost")
args = parser.parse_args()

http = urllib3.PoolManager()
metrics_endpoint = "http://" + args.host + ":6034/metrics"
r = http.request('GET', metrics_endpoint)

results = {}
def parse_execution_time_line(line):
	line = line[24:] # Strip away text at start
	# Grab latency value (microseconds)
	[line, latency_value] = line.rsplit("}", 1)

	# Grab quantile value
	[line, quantile] = line.rsplit("quantile=", 1)

	# Strip out other values
	[line, other] = line.rsplit(",event_type=\"", 1)

	# Grab query text
	[line, query_text] = line.rsplit("query=", 1)

	return query_text, eval(quantile), eval(latency_value)*1000

def parse_execution_count_line(line):
	line = line[24:] # Strip away text at start
	# Grab latency value (ms)
	[line, count] = line.rsplit("}", 1)

	# Strip out other values
	[line, other] = line.rsplit(",event_type=\"", 1)

	# Grab query text
	[line, query_text] = line.rsplit("query=", 1)

	return query_text, count

for line in r.data.decode('utf-8').split("\n"):
	if line.find("query_log_execution_time{") != -1:
		query_text, quantile, latency = parse_execution_time_line(line)
		if query_text not in results:
			results[query_text] = {}

		results[query_text]["p" + quantile] = latency

	if line.find("query_log_execution_time_count{") != -1:
		text, query_count = parse_execution_count_line(line)
		results[text]["count"] = query_count

tabulated_rows = []
for k in results.keys():
	tabulated_rows.append([k, results[k]["count"], results[k]["p0.5"], results[k]["p0.9"], results[k]["p0.99"]])
	tabulated_rows.append(SEPARATING_LINE)

try: 
	if len(results.keys()) > 0:
		print (tabulate(tabulated_rows, headers=["query text", "count", "p50 (ms)", "p90 (ms)", "p99 (ms)"], tablefmt="psql", floatfmt=".3f", maxcolwidths=70))
	else:
		raise ValueError("Oops! There are no query-specific metrics. Have you run a query yet? Did you pass --query-log and --query-log-ad-hoc flags when running ReadySet?")
except ValueError as err:
	print (str(err.args[0]))
