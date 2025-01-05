# Monitoring Stack

## Kubernetes
I used my GKE setup for this project, instructions found at: https://github.com/shreyasgune/terragrunt-sgune 

But you can use Minikube as well:
```
minikube start --cpus=2 --memory=2048 --disk-size=10g --driver=docker --kubernetes-version=v1.25.0

```

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

kubectl create ns gman-go-server

helm install --dry-run --debug --namespace gman-go-server sgune-server ./gman-go-server  # dry run

helm upgrade --install --cleanup-on-fail --namespace gman-go-server sgune-server -f gman-go-server/values/gke.yaml  ./gman-go-server

helm diff upgrade --namespace gman-go-server sgune-server -f gman-go-server/values/gke.yaml  ./gman-go-server -C3

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

helm upgrade --cleanup-on-fail --install --namespace logging -f loki-stack/values/custom-values.yaml loki-stack ./loki-stack

helm diff upgrade --namespace logging -f loki-stack/values/custom-values.yaml loki-stack ./loki-stack -C3


```
- Loki server serves as storage, storing the logs in a time series database, but it won’t index them. To visualize the logs, you need to extend Loki with Grafana in combination with LogQL.

- Loki agents will be deployed as a DaemonSet, and they're in charge of collecting logs from various pods/containers of our nodes. Loki supports various types of agents, but the default one is called Promtail.

### Promtail
Promtail has a configuration file (config.yaml or promtail.yaml), which will be stored in the config map when deploying it with the help of the helm chart.

In the config file, you need to define several things:

- Server settings. Meaning which port the agent is listening to.

- Promtail also exposes an HTTP endpoint that will allow you to: 
  - Push logs to another Promtail or Loki server.
  - And also a “/metrics” that returns Promtail metrics in a Prometheus format to include Loki in your observability. You can track the number of bytes exchanged, stream ingested, number of active or failed targets..and more.

- Client configuration. To specify how it connects to Loki.

- Positioning. To make Promtail reliable in case it crashes and avoid duplicates.

- Scrape config. That will specify each job that will be in charge of collecting the logs.

- Relabel config. That will control what to ingest, what to drop, what type of metadata to attach to the log line.

### Access Loki
`kubectl port-forward svc/loki -n monitoring 3100`

DNS: http://loki-stack.logging.svc.cluster.local:3100

### Access Promtail
`kubectl port-forward pod/loki-stack-promtail -n logging 9080`

### Access Alert Manager
`kubectl port-forward svc/kube-prometheus-stack-alertmanager -n monitoring 9093`


## Setup Tempo
```
helm pull grafana/tempo --untar --untardir .

helm upgrade --cleanup-on-fail --install --namespace tracing -f tempo/values/custom-values.yaml loki-stack ./tempo

helm diff upgrade --namespace tracing -f tempo/values/custom-values.yaml loki-stack ./tempo -C3

```
Tempo Configuration is explained here: https://github.com/shreyasgune/grafana-tempo 


--------------
![](https://i.imgur.com/sJozHyC.png)
![](https://i.imgur.com/3ZNmCut.png)
![](https://i.imgur.com/cl9ORxa.png)
![](https://i.imgur.com/RHRCAJd.png)
![](https://i.imgur.com/V7g1Tdz.png)
![](https://i.imgur.com/Kcx3R8H.png)
![](https://i.imgur.com/b1M763T.png)
![](https://i.imgur.com/ErQJyft.png)
![](https://i.imgur.com/jtefGfM.png)
![](https://i.imgur.com/jqNcdLD.png)