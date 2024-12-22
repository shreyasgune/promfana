# Monitoring Stack

## Candidate App
- [Person API](https://github.com/shreyasgune/sgune-go/blob/goreference/person-api-server/README.md)

- Test it: 
```
docker run -p 8080:2112 -d --name person-api-server shreyasgune/gman-go-server

curl http://localhost:8080/people
curl http://locahost:8080/metrics
```
- Helm it up
```
helm plugin install https://github.com/databus23/helm-diff


helm create gman-go-server

helm install --dry-run --debug --namespace gman-go-server sgune-server ./gman-go-server  # dry run

helm upgrade --cleanup-on-fail --namespace gman-go-server --install sgune-server ./gman-go-server

helm diff upgrade sgune-server --namespace gman-go-server ./gman-go-server -C3

#NOTES
Get the application URL by running these commands: 
  export POD_NAME=$(kubectl get pods --namespace gman-go-server -l "app.kubernetes.io/name=gman-go-server,app.kubernetes.io/instance=sgune" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace gman-go-server $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace gman-go-server port-forward $POD_NAME 8080:$CONTAINER_PORT

```


## Solution Stack
- Prometheus for metrics collection
- Grafana for visualization
- Alertmanager for alerting
- Node Exporter for host metrics
- Log Aggregation with Loki
- Distributed Tracing with Jaeger

## Setup

### Kube Prometheus Stack
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm pull prometheus-community/kube-prometheus-stack --untar --untardir .

kubectl create namespace monitoring

helm install --dry-run --debug --namespace monitoring kube-prometheus-stack -f kube-prometheus-stack/values/custom-values.yaml ./kube-prometheus-stack  # dry run

helm upgrade --cleanup-on-fail --install --namespace monitoring kube-prometheus-stack -f kube-prometheus-stack/values/custom-values.yaml ./kube-prometheus-stack

helm diff upgrade --namespace monitoring  kube-prometheus-stack -f kube-prometheus-stack/values/custom-values.yaml ./kube-prometheus-stack -C3

NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=kube-prometheus-stack"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

```

### Access Prometheus
`kubectl port-forward svc/prometheus-operated -n monitoring 9090`

### Access Grafana
`kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000`

## Setup Loki
```

kubectl create namespace logging

helm repo add grafana https://grafana.github.io/helm-charts

helm pull grafana/loki-stack --untar --untardir .

helm upgrade --cleanup-on-fail --install --namespace logging loki-stack ./loki-stack

helm diff upgrade --namespace logging loki-stack ./loki-stack -C3


```

### Access Loki
`kubectl port-forward svc/loki -n monitoring 3100`

### Access Alert Manager
`kubectl port-forward svc/kube-prometheus-stack-alertmanager -n monitoring 9093`