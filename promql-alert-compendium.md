# PROMQL and ALERTS Compendium
Some of the Queries and Alerts that I think, we should be implementing. 
> _I made this so that I can refer back to it when I'm building monitoring into my apps._

---

## Alerting Metrics: 
Metrics that trigger alerts based on thresholds, trends, or anomalies. These are critical for proactively identifying issues in your infrastructure, applications, or services.

### Alerting Metric Queries

#### CPU Usage: Alerts when CPU usage exceeds a certain threshold.
- `cpu_usage_seconds_total{job="node_exporter"} > 90`
```
alert: HighCPUUsage
expr: avg(rate(node_cpu_seconds_total{mode="user"}[5m])) by (instance) > 0.9
for: 5m
labels:
  severity: critical
annotations:
  summary: "CPU usage above 90% for instance {{ $labels.instance }}"
  description: "The CPU usage on instance {{ $labels.instance }} has been above 90% for the last 5 minutes."

```


#### Memory Usage: Alert when memory usage is too high or when available memory is critically low.
- `node_memory_MemAvailable_bytes < 1000000000  # Less than 1 GB available`
```
alert: LowMemory
expr: node_memory_MemAvailable_bytes < 1000000000  # Less than 1GB available
for: 10m
labels:
  severity: critical
annotations:
  summary: "Low available memory on instance {{ $labels.instance }}"
  description: "Available memory on instance {{ $labels.instance }} is less than 1GB for the last 10 minutes."

```


#### Disk Space: Alert when disk usage exceeds a certain percentage.
```
node_filesystem_avail_bytes{job="node_exporter",fstype="ext4"} 
/ 
node_filesystem_size_bytes{job="node_exporter",fstype="ext4"} < 0.1  

# less than 10% free
```

```
alert: HighDiskUsage
expr: node_filesystem_avail_bytes{fstype="ext4"} / node_filesystem_size_bytes{fstype="ext4"} < 0.1  # Less than 10% free
for: 10m
labels:
  severity: warning
annotations:
  summary: "High disk usage on instance {{ $labels.instance }}"
  description: "Disk usage on instance {{ $labels.instance }} is above 90%. Available space is less than 10%."
```

#### Network Throughput: Alert on high or low network activity (e.g., network saturation)
- `rate(node_network_receive_bytes_total[5m]) > 1000000  # Rate of network receive > 1MB/s`


#### HTTP Request Latency: Alert when the average response time of HTTP requests exceeds a threshold.
- `histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le)) > 2  # 95th percentile > 2 seconds`

```
alert: HighRequestLatency
expr: histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, instance)) > 2
for: 1m
labels:
  severity: critical
annotations:
  summary: "High request latency for instance {{ $labels.instance }}"
  description: "The 95th percentile of HTTP request response time for instance {{ $labels.instance }} is above 2 seconds."

```


#### Error Rate: Alert when the error rate (e.g., HTTP 500 responses) is too high.
- `rate(http_requests_total{status="500"}[5m]) > 0.1  # More than 0.1 errors per second`
- Example Alert
```
alert: HighErrorRate
expr: rate(http_requests_total{status="500"}[5m]) / rate(http_requests_total[5m]) > 0.05
for: 1m
labels:
  severity: critical
annotations:
  summary: "High error rate on service {{ $labels.service }}"
  description: "More than 5% of requests to service {{ $labels.service }} are failing with 500 status code."
```


#### Service Unavailability: Alert when a service is down or unreachable (e.g., no successful HTTP responses)
- `up{job="my_service"} == 0  # Service is down`

```
alert: ServiceDown
expr: up{job="my_service"} == 0
for: 5m
labels:
  severity: critical
annotations:
  summary: "Service is down: {{ $labels.instance }}"
  description: "The service at {{ $labels.instance }} is unreachable or down."

```


#### Database Connections: Alert when the number of active database connections exceeds a threshold.
- `db_connections{job="db_exporter"} > 100  # More than 100 active connections`

```
alert: HighDatabaseConnections
expr: db_connections{job="db_exporter"} > 100  # More than 100 active connections
for: 5m
labels:
  severity: warning
annotations:
  summary: "High number of database connections"
  description: "The number of active database connections has exceeded 100 in the last 5 minutes."

```


#### Application Health: Alert when an application is in an unhealthy state
- `app_health_status{job="my_app"} == 0  # Application is unhealthy`


#### Service Availability: Alert when a service is unavailable for an extended period
- `increase(service_down_total[5m]) > 0  # Service has been down in the last 5 minutes`  


---

## Debugging Metrics: 
Metrics that provide detailed information to investigate the root cause of issues when they occur. These metrics help understand the context and diagnose problems.

### Debugging Metric Queries
Debugging metrics provide more granular details about the behavior of your systems and services. They help you understand the context of issues when they arise and help with troubleshooting.


#### CPU Utilization by Process: Tracks CPU usage per process or service for debugging resource hogs.
- `process_cpu_seconds_total{job="my_service"}`


#### Memory Usage by Process: Memory consumption by individual processes or services.
- `process_resident_memory_bytes{job="my_service"}`


#### Disk I/O by Process: Tracks disk read/write operations by process
```
process_disk_read_bytes_total{job="my_service"}
process_disk_written_bytes_total{job="my_service"}

```

#### Request Duration by Path: Tracks how long requests take per endpoint or path, which can help isolate performance bottlenecks.
- `http_request_duration_seconds{method="GET",status="200",path="/api/v1/metrics"}`

#### Request Count by Status Code: Breakdown of HTTP requests by response code, useful for debugging issues with specific responses.
- `http_requests_total{status="404"}  # Track 404 errors to identify missing endpoints`


#### Custom App Debugging Metrics (successful logins, item purchases etc)
```
app_successful_logins_total{job="my_app"}
app_failed_logins_total{job="my_app"}

```

#### Slow Queries: Tracks queries that are taking longer than expected
- `db_slow_queries_total{job="db_exporter"} > 10  # More than 10 slow queries`

#### Query Execution Breakdown: Tracks the time spent on different parts of query execution
- `db_query_time_seconds{job="db_exporter"}  # Break down by query stage (e.g., "planning", "execution")`

#### Service Response Time Breakdown: Tracks the response time for different types of requests within your services.
- `service_request_duration_seconds{status="200",service="my_service"}  # Break down by service`

#### Queue Length: Tracks the length of request queues or processing pipelines, which could indicate backlog or delays.
- `queue_length{job="worker_service"}  # Track queue length in a worker service`

```
alert: HighQueueLength
expr: queue_length{job="worker_service"} > 1000  # More than 1000 jobs in the queue
for: 5m
labels:
  severity: warning
annotations:
  summary: "High queue length in worker service"
  description: "The queue length for worker service {{ $labels.instance }} has exceeded 1000 jobs."

```

