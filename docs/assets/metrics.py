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
readyset_results = {}
def parse_execution_time_line(line):
	line = line[24:] # Strip away text at start
	# Grab latency value (microseconds)
	[line, latency_value] = line.rsplit("}", 1)

	# Grab quantile value
	[line, quantile] = line.rsplit("quantile=", 1)

	#Grab database type
	[line, database_type] = line.rsplit("database_type=", 1)

	# Strip out other values
	[line, other] = line.rsplit(",event_type=\"", 1)

	# Grab query text
	[line, query_text] = line.rsplit("query=", 1)

	return query_text, database_type, eval(quantile), eval(latency_value)*1000

def parse_execution_count_line(line):
	line = line[24:] # Strip away text at start
	# Grab latency value (ms)
	[line, count] = line.rsplit("}", 1)

	#Grab database type
	[line, database_type] = line.rsplit("database_type=", 1)

	# Strip out other values
	[line, other] = line.rsplit(",event_type=\"", 1)

	# Grab query text
	[line, query_text] = line.rsplit("query=", 1)

	return query_text, database_type, count

for line in r.data.decode('utf-8').split("\n"):
	if line.find("query_log_execution_time{") != -1:
		query_text, database_type, quantile, latency = parse_execution_time_line(line)
		if "readyset" in database_type:
			if query_text not in readyset_results:
				readyset_results[query_text] = {}

			readyset_results[query_text]["p" + quantile] = latency
		else:
			if query_text not in results:
				results[query_text] = {}

			results[query_text]["p" + quantile] = latency

	if line.find("query_log_execution_time_count{") != -1:
		query_text, database_type, query_count = parse_execution_count_line(line)

		if "readyset" in database_type:
			readyset_results[query_text]["count"] = query_count
		else:
			results[query_text]["count"] = query_count

tabulated_rows = []
tabulated_readyset_rows = []
for k in results.keys():
	tabulated_rows.append([k, results[k]["count"], results[k]["p0.5"], results[k]["p0.9"], results[k]["p0.99"]])
	tabulated_rows.append(SEPARATING_LINE)

for k in readyset_results.keys():
	tabulated_readyset_rows.append([k, readyset_results[k]["count"], readyset_results[k]["p0.5"], readyset_results[k]["p0.9"], readyset_results[k]["p0.99"]])
	tabulated_readyset_rows.append(SEPARATING_LINE)

try: 
	if len(results.keys()) > 0 or len(readyset_results.keys()) > 0:
		if (len(results.keys()) > 0):
			print ("Proxied Queries")
			print (tabulate(tabulated_rows, headers=["query text", "count", "p50 (ms)", "p90 (ms)", "p99 (ms)"], tablefmt="psql", floatfmt=".3f", maxcolwidths=70))

		if (len(readyset_results.keys()) > 0):
			print ("ReadySet Queries")
			print (tabulate(tabulated_readyset_rows, headers=["query text", "count", "p50 (ms)", "p90 (ms)", "p99 (ms)"], tablefmt="psql", floatfmt=".3f", maxcolwidths=70))
	else:
		raise ValueError("Oops! There are no query-specific metrics. Have you run a query yet? Did you pass --query-log and --query-log-ad-hoc flags when running ReadySet?")
except ValueError as err:
	print (str(err.args[0]))
