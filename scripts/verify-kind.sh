#!/usr/bin/env bash
set -euo pipefail

context="${KUBE_CONTEXT:-kind-cka-cluster2}"
namespace="${NAMESPACE:-go-web-app-kind}"
local_port="${LOCAL_PORT:-18080}"
log_file="/tmp/go-web-app-port-forward.log"

kubectl --context "${context}" --namespace "${namespace}" get deployment,service,ingress

kubectl --context "${context}" --namespace "${namespace}" \
  port-forward service/go-web-app "${local_port}:80" >"${log_file}" 2>&1 &
forward_pid=$!
trap 'kill "${forward_pid}" >/dev/null 2>&1 || true' EXIT

for _ in {1..30}; do
  if curl --fail --silent --show-error "http://127.0.0.1:${local_port}/healthz" >/dev/null 2>&1; then
    echo "Application health check passed at http://127.0.0.1:${local_port}/healthz"
    curl --fail --silent --show-error "http://127.0.0.1:${local_port}/home" >/dev/null
    echo "Application page check passed."
    exit 0
  fi
  sleep 1
done

echo "Application did not become reachable. Port-forward log:"
sed -n '1,80p' "${log_file}"
exit 1
