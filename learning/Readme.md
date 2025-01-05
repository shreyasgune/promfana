
## Get Started

```
cd src
docker build -t shreyasgune/fastapi .

cd ..

docker compose up

```

<details><summary>OUTPUT</summary>

```diff
docker compose up                                                                    
[+] Running 3/0
 ? Container learning-fastapi-app-1  Created                                                                                   0.0s
 ? Container learning-prometheus-1   Created                                                                                   0.0s
 ? Container learning-grafana-1      Created                                                                                   0.0s
Attaching to fastapi-app-1, grafana-1, prometheus-1
prometheus-1   | ts=<REDACTED>09:49:24.088Z caller=main.go:491 level=info msg="No time or size retention was set so using the default time retention" duration=15d
prometheus-1   | ts=<REDACTED>09:49:24.088Z caller=main.go:535 level=info msg="Starting Prometheus Server" mode=server version="(version=2.37.0, branch=HEAD, revision=b41e0750abf5cc18d8233161560731de05199330)"
prometheus-1   | ts=<REDACTED>09:49:24.088Z caller=main.go:540 level=info build_context="(go=go1.18.4, user=root@0ebb6827e27f, date=20220714-15:13:18)"
prometheus-1   | ts=<REDACTED>09:49:24.089Z caller=main.go:541 level=info host_details="(Linux 5.15.167.4-microsoft-standard-WSL2 #1 SMP Tue Nov 5 00:21:55 UTC 2024 x86_64 5a1926c7a2a8 )"
prometheus-1   | ts=<REDACTED>09:49:24.089Z caller=main.go:542 level=info fd_limits="(soft=1048576, hard=1048576)"
prometheus-1   | ts=<REDACTED>09:49:24.089Z caller=main.go:543 level=info vm_limits="(soft=unlimited, hard=unlimited)"
prometheus-1   | ts=<REDACTED>09:49:24.099Z caller=web.go:553 level=info component=web msg="Start listening for connections" address=0.0.0.0:9090
prometheus-1   | ts=<REDACTED>09:49:24.101Z caller=main.go:972 level=info msg="Starting TSDB ..."
prometheus-1   | ts=<REDACTED>09:49:24.106Z caller=tls_config.go:195 level=info component=web msg="TLS is disabled." http2=false
prometheus-1   | ts=<REDACTED>09:49:24.114Z caller=head.go:493 level=info component=tsdb msg="Replaying on-disk memory mappable chunks if any"
prometheus-1   | ts=<REDACTED>09:49:24.115Z caller=head.go:536 level=info component=tsdb msg="On-disk memory mappable chunks replay completed" duration=934.83µs
prometheus-1   | ts=<REDACTED>09:49:24.116Z caller=head.go:542 level=info component=tsdb msg="Replaying WAL, this may take a while"
prometheus-1   | ts=<REDACTED>09:49:24.123Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=0 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.128Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=1 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.130Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=2 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.134Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=3 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.136Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=4 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.138Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=5 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.138Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=6 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.140Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=7 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.141Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=8 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.142Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=9 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.143Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=10 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.143Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=11 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.146Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=12 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.157Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=13 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.191Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=14 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.191Z caller=head.go:613 level=info component=tsdb msg="WAL segment loaded" segment=15 maxSegment=15
prometheus-1   | ts=<REDACTED>09:49:24.192Z caller=head.go:619 level=info component=tsdb msg="WAL replay completed" checkpoint_replay_duration=164.59µs wal_replay_duration=75.740157ms total_replay_duration=77.050357ms
prometheus-1   | ts=<REDACTED>09:49:24.197Z caller=main.go:993 level=info fs_type=EXT4_SUPER_MAGIC
prometheus-1   | ts=<REDACTED>09:49:24.197Z caller=main.go:996 level=info msg="TSDB started"
prometheus-1   | ts=<REDACTED>09:49:24.197Z caller=main.go:1177 level=info msg="Loading configuration file" filename=/etc/prometheus/prometheus.yml
prometheus-1   | ts=<REDACTED>09:49:24.203Z caller=main.go:1214 level=info msg="Completed loading of configuration file" filename=/etc/prometheus/prometheus.yml totalDuration=5.091882ms db_storage=3.02µs remote_storage=2.67µs web_handler=1.09µs query_engine=2.42µs scrape=4.427632ms scrape_sd=86µs notify=2.48µs notify_sd=2.73µs rules=3.17µs tracing=11.05µs
prometheus-1   | ts=<REDACTED>09:49:24.203Z caller=main.go:957 level=info msg="Server is ready to receive web requests."
prometheus-1   | ts=<REDACTED>09:49:24.203Z caller=manager.go:941 level=info component="rule manager" msg="Starting rule manager..."
grafana-1      | logger=settings t=<REDACTED>09:49:24.348332344Z level=info msg="Starting Grafana" version=9.0.0 commit=b5c56f6371 branch=HEAD compiled=2022-06-13T12:06:48Z
grafana-1      | logger=settings t=<REDACTED>09:49:24.348924704Z level=info msg="Config loaded from" file=/usr/share/grafana/conf/defaults.ini
grafana-1      | logger=settings t=<REDACTED>09:49:24.349010924Z level=info msg="Config loaded from" file=/etc/grafana/grafana.ini
grafana-1      | logger=settings t=<REDACTED>09:49:24.349030444Z level=info msg="Config overridden from command line" arg="default.paths.data=/var/lib/grafana"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349039134Z level=info msg="Config overridden from command line" arg="default.paths.logs=/var/log/grafana"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349046344Z level=info msg="Config overridden from command line" arg="default.paths.plugins=/var/lib/grafana/plugins"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349056214Z level=info msg="Config overridden from command line" arg="default.paths.provisioning=/etc/grafana/provisioning"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349065864Z level=info msg="Config overridden from command line" arg="default.log.mode=console"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349081464Z level=info msg="Config overridden from Environment variable" var="GF_PATHS_DATA=/var/lib/grafana"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349090044Z level=info msg="Config overridden from Environment variable" var="GF_PATHS_LOGS=/var/log/grafana"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349096854Z level=info msg="Config overridden from Environment variable" var="GF_PATHS_PLUGINS=/var/lib/grafana/plugins"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349103434Z level=info msg="Config overridden from Environment variable" var="GF_PATHS_PROVISIONING=/etc/grafana/provisioning"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349327254Z level=info msg="Config overridden from Environment variable" var="GF_SECURITY_ADMIN_PASSWORD=*********"
grafana-1      | logger=settings t=<REDACTED>09:49:24.349553314Z level=info msg="Path Home" path=/usr/share/grafana
grafana-1      | logger=settings t=<REDACTED>09:49:24.349835173Z level=info msg="Path Data" path=/var/lib/grafana
grafana-1      | logger=settings t=<REDACTED>09:49:24.349864333Z level=info msg="Path Logs" path=/var/log/grafana
grafana-1      | logger=settings t=<REDACTED>09:49:24.350557413Z level=info msg="Path Plugins" path=/var/lib/grafana/plugins
grafana-1      | logger=settings t=<REDACTED>09:49:24.350733283Z level=info msg="Path Provisioning" path=/etc/grafana/provisioning
grafana-1      | logger=settings t=<REDACTED>09:49:24.350754443Z level=info msg="App mode production"
grafana-1      | logger=sqlstore t=<REDACTED>09:49:24.351251193Z level=info msg="Connecting to DB" dbtype=sqlite3
grafana-1      | logger=migrator t=<REDACTED>09:49:24.399694205Z level=info msg="Starting DB migrations"
grafana-1      | logger=migrator t=<REDACTED>09:49:24.411970461Z level=info msg="migrations completed" performed=0 skipped=422 duration=1.24348ms
grafana-1      | logger=plugin.manager t=<REDACTED>09:49:24.609369171Z level=info msg="Plugin registered" pluginId=input
grafana-1      | logger=secrets t=<REDACTED>09:49:24.61146177Z level=info msg="Envelope encryption state" enabled=true currentprovider=secretKey.v1
grafana-1      | logger=query_data t=<REDACTED>09:49:24.623994805Z level=info msg="Query Service initialization"
grafana-1      | logger=live.push_http t=<REDACTED>09:49:24.62906513Z level=info msg="Live Push Gateway initialization"
grafana-1      | logger=infra.usagestats.collector t=<REDACTED>09:49:24.780334118Z level=info msg="registering usage stat providers" usageStatsProvidersLen=2
grafana-1      | logger=grafanaStorageLogger t=<REDACTED>09:49:24.784244358Z level=info msg="storage starting"
grafana-1      | logger=ngalert t=<REDACTED>09:49:24.784413978Z level=info msg="warming cache for startup"
grafana-1      | logger=http.server t=<REDACTED>09:49:24.799116379Z level=info msg="HTTP Server Listen" address=[::]:3000 protocol=http subUrl= socket=
grafana-1      | logger=ngalert.multiorg.alertmanager t=<REDACTED>09:49:24.800471902Z level=info msg="starting MultiOrg Alertmanager"
fastapi-app-1  | INFO:     Started server process [1]
fastapi-app-1  | INFO:     Waiting for application startup.
fastapi-app-1  | INFO:     Application startup complete.
fastapi-app-1  | INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
fastapi-app-1  | INFO:     172.18.0.4:54304 - "GET /metrics HTTP/1.1" 200 OK
```
</details>




### Usage
- Prometheus is at `localhost:9090`
- Metrics are at `localhost:8000/metrics`
- Grafana is at `localhost:3000`
- App is at `localhost:8000/ and localhost:8000/item`

### CURL Calls
- GET
```
curl --location 'http://localhost:8000/'
```

- POST:
```
curl --location 'http://localhost:8000/items' \
--header 'Content-Type: application/json' \
--data '{
    "name": "Test Item"
}'
```
- GET Item:
```
curl --location 'http://localhost:8000/items/<num>'
```

- PUT:
```
curl --location --request PUT 'http://localhost:8000/items/3' \
--header 'Content-Type: application/json' \
--data '{
    "name": "Updated Item"
}'
```
- DELETE:
```
curl --location --request DELETE 'http://localhost:8000/items/1'
```

- Metrics:
```
curl --location 'http://localhost:8000/metrics'

```


# PROMQL Examples
- `delta(process_cpu_usage[5m])`

Explanation: This query calculates the change (delta) in the process_cpu_usage metric over the last 5 minutes. It helps to measure the CPU usage variation over time for a given process.

- `rate(http_request_total{method="GET", path="/metrics"}[5m])`

Explanation: This calculates the rate (per second) of HTTP requests for the /metrics path with the GET method over the last 5 minutes. It is useful for measuring the traffic or requests to the metrics endpoint.

- `irate(http_request_total{method="GET", path="/metrics"}[5m])`

Explanation: Similar to the previous query, but uses the irate function to calculate the instantaneous rate over the last 5 minutes. It is commonly used to get a more granular measure of the request rate.

- `sum by (method) (rate(http_request_total[5m]))`

Explanation: This sums the rate of HTTP requests over the last 5 minutes, grouped by the method label (e.g., GET, POST). It is useful to see the total rate of requests, divided by the HTTP method.

- `avg_over_time(http_request_total{path="/"}[10m])`

Explanation: This calculates the average number of HTTP requests to the root path (/) over the last 10 minutes. This helps to track the average traffic over time.

- `histogram_quantile(0.9, sum by (le) (http_request_duration_seconds_bucket{path="/"}))`

Explanation: This query calculates the 90th percentile of request durations for the root path (/). It uses the http_request_duration_seconds_bucket metric and 
sums by the le (less than or equal) label.

- `(rate(http_request_duration_seconds_sum{path="/"}[3m]) / rate(http_request_duration_seconds_count{path="/"}[3m])) * 1000`

Explanation: This calculates the average request duration in milliseconds (ms) for the root path (/) over the last 3 minutes by dividing the total time spent on requests by the total number of requests.

- `increase(http_request_total{path="/"}[10m])`

Explanation: This query calculates the total increase in the number of HTTP requests to the root path (/) over the last 10 minutes. It helps to track how many requests have been received during that period.

- `label_replace(http_request_total, "gman_label", "$1", "path", "(\/.*)")`

Explanation: This query uses label_replace to create a new label (gman_label) by extracting part of the path label using a regular expression. The result is a modified metric with a new label.

- `label_join(http_request_total{path="/"}, "instance_info", ":", "job", "instance")`

Explanation: This joins the job and instance labels to create a new instance_info label, separated by a colon (:), for HTTP requests to the root path (/).

- `deriv(process_resident_memory_bytes{job="prometheus"}[1h]) / (1024*1024)`

Explanation: This calculates the rate of change (derivative) of the process_resident_memory_bytes metric for the Prometheus job over the last hour and converts the result from bytes to megabytes (MB).

- `topk(5, rate(http_request_total[2h]))`

Explanation: This query finds the top 5 metrics based on the rate of HTTP requests over the last 2 hours. It's useful for identifying the most active HTTP request sources.