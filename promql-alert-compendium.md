# PROMQL and ALERTS Compendium
Some of the Queries and Alerts that I think, we should be implementing. 
> _I made this so that I can refer back to it when I'm building monitoring into my apps._

---

## Alerting Metrics: 
Metrics that trigger alerts based on thresholds, trends, or anomalies. These are critical for proactively identifying issues in your infrastructure, applications, or services.

### Alerting Metric Queries

#### CPU Usage: Alerts when CPU usage exceeds a certain threshold.
- `cpu_usage_seconds_total{job="node_exporter"} > 90`
```yaml
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
```yaml
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
```yaml
node_filesystem_avail_bytes{job="node_exporter",fstype="ext4"} 
/ 
node_filesystem_size_bytes{job="node_exporter",fstype="ext4"} < 0.1  

# less than 10% free
```

```yaml
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

```yaml
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
```yaml
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

```yaml
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

```yaml
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

```yaml
alert: HighQueueLength
expr: queue_length{job="worker_service"} > 1000  # More than 1000 jobs in the queue
for: 5m
labels:
  severity: warning
annotations:
  summary: "High queue length in worker service"
  description: "The queue length for worker service {{ $labels.instance }} has exceeded 1000 jobs."

```

---

## SLO for Error Rate using Recording Rules

- My Successful requests SLO is 99.9%
> Note about SLO. So, we picked an SLO of 99.9%, meanning, we can allow 0.1% of errors. But how many error can we allow while still respecting our SLO? Lets do the maths.

```
Since we don't know the number of HTTP requests per minute, we'll assume it's x. Then, the maximum allowed errors per minute would be x * 0.001.

Maximum Allowed Errors per 10m Window = x * 0.001 / 6 (since there are 6 10-minute windows in an hour)

Maximum Allowed Errors per 10m Window = 1,000,000 / 6

Maximum Allowed Errors per 10m Window = 166,667
```
#### So we need to tune our SLO based on Burn Rate instead of time windows because:
- Variable error rates: Error rates can vary significantly over time, making time windows a less accurate representation of the actual error rate.

- Error budget consumption: Burn rate provides a more accurate picture of how quickly your available error budget is being consumed. This is particularly important when you have a limited error budget (e.g., 0.1% SLO).

- Proactive decision-making: By monitoring burn rate, you can proactively identify potential issues before your error budget is depleted, allowing for more effective error prevention and mitigation strategies.

#### Tuning SLO based on Burn Rate
- Dynamic SLO adjustments: By monitoring burn rate, you can adjust your SLO in real-time to reflect changes in error rates, ensuring that your SLO remains accurate and effective.
- Error budget optimization: Burn rate analysis can help you optimize your error budget by identifying areas where you can reduce errors and allocate resources more efficiently.
```
Error rate for a 99.9% SLO : Time to exhaustion
0.1 % exhaustion in 30 days
0.2 % exhaustion in 15 days
1.0 % exhaustion in 03 days
100 % exhaustion in 43 minutes 
```
- `Burn Rate = (1 - SLO) / (Error Ratio)`
- `Error Budget Consumption = (Burn Rate * Alerting Window) / (period)`

#### Suggested Strategy
```
2%  budget_consumption in long_window:1.0h with burn_rate:14.4 AND 2%  budget_consumption in short_window:5m with burn_rate:14.4
5%  budget_consumption in long_window:6.0h with burn_rate:6.0  AND 5%  budget_consumption in short_window:30m with burn_rate:6.0
10% budget_consumption in long_window:3.0d with burn_rate:1.0  AND 10% budget_consumption in long_window:3d with burn_rate:1.0
```
- Alert Config Logic
```yaml
expr: (
        (
          job:slo_errors_per_request:ratio_rate1h{job="my-job"} > (14.4 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate5m{job="my-job"} > (14.4 * 0.001)
        )
        or
        (
          job:slo_errors_per_request:ratio_rate6h{job="my-job"} > (6.0 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate30m{job="my-job"} > (6.0 * 0.001)
        )
      )
severity: page

expr: (
        (
          job:slo_errors_per_request:ratio_rate24h{job="my-job"} > (3 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate2h{job="my-job"} > (3 * 0.001)
        )
        or
        (
          job:slo_errors_per_request:ratio_rate3d{job="my-job"} > 0.001
          and
          job:slo_errors_per_request:ratio_rate6h{job="my-job"} > 0.001
        )
      )
severity: ticket
```
- Associated Alert YAML
```yaml

alert: HighErrorRatePage
expr: (
        (
          job:slo_errors_per_request:ratio_rate1h{job="my-job"} > (14.4 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate5m{job="my-job"} > (14.4 * 0.001)
        )
        or
        (
          job:slo_errors_per_request:ratio_rate6h{job="my-job"} > (6.0 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate30m{job="my-job"} > (6.0 * 0.001)
        )
      )
labels:
  severity: page
annotations:
  summary: "High error rate for job {{ $labels.job }}"
  description: "Error rate for job {{ $labels.job }} has exceeded 0.1% ({{ $value }} errors per minute) for {{ $interval }}"


alert: HighErrorRateTicket
expr: (
        (
          job:slo_errors_per_request:ratio_rate24h{job="my-job"} > (3 * 0.001)
          and
          job:slo_errors_per_request:ratio_rate2h{job="my-job"} > (3 * 0.001)
        )
        or
        (
          job:slo_errors_per_request:ratio_rate3d{job="my-job"} > 0.001
          and
          job:slo_errors_per_request:ratio_rate6h{job="my-job"} > 0.001
        )
      )
labels:
  severity: ticket
annotations:
  summary: "High error rate for job {{ $labels.job }}"
  description: "Error rate for job {{ $labels.job }} has exceeded 0.1% ({{ $value }} errors per minute) for {{ $interval }}"

```
- Recording Rule YAML
```yaml
    groups:
  - name: slo_errors_per_request_rules
    interval: 1h
    rules:
      - record: job:slo_errors_per_request:ratio_rate1h
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[1h])) /
          sum by (job) (rate(http_requests_total[1h]))
        labels:
          error_type: "total_4xx_and_5xx_1h"

      - record: job:slo_errors_per_request:ratio_rate6h
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[6h])) /
          sum by (job) (rate(http_requests_total[6h]))
        labels:
          error_type: "total_4xx_and_5xx_6h"

      - record: job:slo_errors_per_request:ratio_rate5m
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[5m])) /
          sum by (job) (rate(http_requests_total[5m]))
        labels:
          error_type: "total_4xx_and_5xx_5m"

      - record: job:slo_errors_per_request:ratio_rate30m
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[30m])) /
          sum by (job) (rate(http_requests_total[30m]))
        labels:
          error_type: "total_4xx_and_5xx_30m"

      - record: job:slo_errors_per_request:ratio_rate1d
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[1d])) /
          sum by (job) (rate(http_requests_total[1d]))
        labels:
          error_type: "total_4xx_and_5xx_1d"

      - record: job:slo_errors_per_request:ratio_rate2h
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[2h])) /
          sum by (job) (rate(http_requests_total[2h]))
        labels:
          error_type: "total_4xx_and_5xx_2h"

      - record: job:slo_errors_per_request:ratio_rate6h
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[6h])) /
          sum by (job) (rate(http_requests_total[6h]))
        labels:
          error_type: "total_4xx_and_5xx_6h"

      - record: job:slo_errors_per_request:ratio_rate3d
        expr: |
          sum by (job) (rate(http_requests_total{status=~"4..|5.."}[3d])) /
          sum by (job) (rate(http_requests_total[3d]))
        labels:
          error_type: "total_4xx_and_5xx_3d"
``` 

#### SLO reference

- Error Budget = (100% - SLO%) × Time Period ==
    - Week: `0.1% × 168 hours = 0.001 × 168 hours = 0.168 hours = 10.08 minutes`
    - Month: `0.1% × 720 hours = 0.001 × 720 hours = 0.72 hours = 43.2 minutes`
    - Quarter: `0.1% × 2160 hours = 0.001 × 2160 hours = 2.16 hours = 129.6 minutes`
    - Year: `0.1% × 8760 hours = 0.001 × 8760 hours = 8.76 hours = 525.6 minutes`
    - Whch means: I want to alert if `error_rate is > 0.1 for [36h]` which would consume 5% of my 30 day budget.
  

- Generic Alert YAML

    ```yaml
    alert: HighErrorRate
    expr: job:error_rate:ratio10m > 0.001  # 0.1% error rate (threshold based on SLO)
    labels:
      severity: critical
    annotations:
      summary: "High error rate for job {{ $labels.job }}"
      description: "The error rate for job {{ $labels.job }} has exceeded 0.1% in the last 10 minutes."
    ```

- Prom Config:

    ```yaml
    rule_files:
      - "error_rate_rules.yml"  # Path to your rule files containing the recording and alerting rules

    scrape_configs:
      - job_name: 'your_job'
        static_configs:
          - targets: ['localhost:8080']
        metrics_path: '/metrics'
    ```
