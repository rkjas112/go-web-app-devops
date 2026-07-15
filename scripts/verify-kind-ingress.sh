#!/usr/bin/env bash
set -euo pipefail

context="${KUBE_CONTEXT:-kind-cka-cluster2}"
local_port="${INGRESS_LOCAL_PORT:-18081}"
log_file="/tmp/go-web-app-ingress-port-forward.log"

kubectl --context "${context}" --namespace ingress-nginx \
  port-forward service/ingress-nginx-controller "${local_port}:80" >"${log_file}" 2>&1 &
forward_pid=$!
trap 'kill "${forward_pid}" >/dev/null 2>&1 || true' EXIT

for _ in {1..30}; do
  if curl --fail --silent --show-error \
    --header 'Host: go-web-app.local' \
    "http://127.0.0.1:${local_port}/healthz" >/dev/null 2>&1; then
    echo "Ingress routing check passed for host go-web-app.local."
    exit 0
  fi
  sleep 1
done

echo "Ingress did not become reachable. Port-forward log:"
sed -n '1,80p' "${log_file}"
exit 1
