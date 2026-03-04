#!/bin/bash
# port-forward.sh — forwards all Kubernetes services to localhost
# Usage: ./port-forward.sh
# Stop: Ctrl+C  or  kill $(cat .pf.pids)

set -e

PIDS=()

cleanup() {
  echo "\nStopping all port-forwards..."
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
  rm -f .pf.pids
  exit 0
}
trap cleanup SIGINT SIGTERM

echo "Starting port-forwards..."

kubectl port-forward -n traefik      svc/traefik             9080:80   &>/tmp/pf-traefik.log      & PIDS+=($!)
kubectl port-forward -n traefik      deploy/traefik          9000:9000 &>/tmp/pf-traefik-dash.log  & PIDS+=($!)
kubectl port-forward -n monitoring   svc/prometheus-server   9090:80   &>/tmp/pf-prometheus.log   & PIDS+=($!)
kubectl port-forward -n monitoring   svc/grafana             9030:80   &>/tmp/pf-grafana.log      & PIDS+=($!)
kubectl port-forward -n argocd       svc/argocd-server       9081:80   &>/tmp/pf-argocd.log       & PIDS+=($!)
kubectl port-forward -n tools        svc/uptime-kuma         9031:3001 &>/tmp/pf-uptime-kuma.log  & PIDS+=($!)

printf '%s\n' "${PIDS[@]}" > .pf.pids

echo ""
echo "  Traefik (HTTP)     →  http://localhost:9080"
echo "  Traefik dashboard  →  http://localhost:9000/dashboard/"
echo "  Prometheus         →  http://localhost:9090"
echo "  Grafana            →  http://localhost:9030  (admin / admin)"
echo "  ArgoCD             →  http://localhost:9081  (admin / see below)"
echo "  Uptime Kuma        →  http://localhost:9031"
echo ""
echo "  Via Traefik Ingress (add to /etc/hosts: 127.0.0.1 grafana.local prometheus.local argocd.local uptime.local):"
echo "  Grafana            →  https://grafana.local:9443"
echo "  Prometheus         →  https://prometheus.local:9443"
echo "  ArgoCD             →  https://argocd.local:9443"
echo "  Uptime Kuma        →  https://uptime.local:9443"
echo ""
echo "ArgoCD password:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" 2>/dev/null | base64 -d && echo || echo "  (secret not ready yet)"
echo ""
echo "Press Ctrl+C to stop all port-forwards"

wait
