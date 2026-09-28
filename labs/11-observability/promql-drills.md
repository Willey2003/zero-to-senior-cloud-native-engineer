# PromQL drills

| Question | Query |
|---|---|
| Requests per second per service | `sum by (service) (rate(http_requests_total[5m]))` |
| Error ratio | `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))` |
| p95 latency | `histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))` |
| CPU used per pod | `sum by (pod) (rate(container_cpu_usage_seconds_total{container!=""}[5m]))` |
| Memory near limit | `container_memory_working_set_bytes / on(pod,container) kube_pod_container_resource_limits{resource="memory"} > 0.9` |
| Pods restarting | `increase(kube_pod_container_status_restarts_total[1h]) > 3` |
| Target down | `up == 0` |
| Disk full in 24h | `predict_linear(node_filesystem_avail_bytes[6h], 86400) < 0` |
| Missing metric | `absent(up{job="api"})` |
