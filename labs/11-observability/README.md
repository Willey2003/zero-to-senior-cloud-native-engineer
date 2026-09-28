# Lab 11: Observability (Prometheus, Grafana, OpenTelemetry)

## Concepts
- **Metrics**: numbers over time (CPU %, requests/sec). Cheap, great for alerts. → Prometheus
- **Logs**: text events. → Loki / Elasticsearch
- **Traces**: the path of one request across services, with timings. → OpenTelemetry + Tempo/Jaeger
- Golden signals: **latency, traffic, errors, saturation**. RED (Rate, Errors, Duration) for services, USE for resources.
- SLI / SLO / error budget: "99.9% of requests succeed in under 300 ms over 30 days".

## Part A: Prometheus (PCA)
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install mon prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
kubectl -n monitoring port-forward svc/mon-grafana 3000:80        # admin / prom-operator (check secret)
kubectl -n monitoring port-forward svc/mon-kube-prometheus-stack-prometheus 9090
```
- Data model: metric name + labels; types counter, gauge, histogram, summary.
- PromQL drills (in `promql-drills.md`): `rate()`, `sum by()`, `histogram_quantile()`, `absent()`, `predict_linear()`.
- Scrape your API: add `prometheus-fastapi-instrumentator`, create a `ServiceMonitor` (`manifests/servicemonitor.yaml`).
- Alerting: `PrometheusRule` (`manifests/alerts.yaml`) → Alertmanager → routing, grouping, silences, inhibition.
- Exporters: node_exporter, blackbox_exporter (probe URLs), recording rules, federation, remote_write, Thanos/Mimir concepts.

## Part B: OpenTelemetry (OTCA)
- Instrument the Python API with the OTel SDK (auto-instrumentation: `opentelemetry-instrument uvicorn app:app`).
- Run the **Collector** with `manifests/otel-collector.yaml`: receivers (otlp) → processors (batch, memory_limiter,
  attributes) → exporters (Prometheus, Tempo/Jaeger, debug). Understand agent vs gateway deployment.
- Context propagation (W3C `traceparent`), spans, attributes, resources, semantic conventions, sampling (head vs tail).
- OTel Operator: auto-inject instrumentation via `Instrumentation` CR.

## Real-world scenarios
1. "Latency spiked at 2 PM." Use p99 `histogram_quantile` + a trace to find the slow downstream call.
2. "We get 500 alerts a day, everyone ignores them." Rewrite alerts on SLO burn rate instead of CPU.
3. "Disk will fill up." `predict_linear(node_filesystem_avail_bytes[6h], 24*3600) < 0`.

**Cert mapping:** PCA, OTCA, parts of KCNA/CNPA.
