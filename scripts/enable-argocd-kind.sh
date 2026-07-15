#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cluster="${KIND_CLUSTER:-cka-cluster2}"
context="${KUBE_CONTEXT:-kind-${cluster}}"
namespace="${NAMESPACE:-go-web-app-kind}"
image="${IMAGE:-go-web-app}"
tag="${TAG:-dev}"

cd "${repo_root}"

kubectl --context "${context}" get namespace argocd >/dev/null
docker image inspect "${image}:${tag}" >/dev/null
kind load docker-image "${image}:${tag}" --name "${cluster}"

helm --kube-context "${context}" --namespace "${namespace}" uninstall go-web-app >/dev/null 2>&1 || true
kubectl --context "${context}" apply -f gitops/applications/go-web-app-kind.yaml
kubectl --context "${context}" --namespace argocd annotate application go-web-app-kind \
  argocd.argoproj.io/refresh=hard --overwrite >/dev/null

for _ in {1..60}; do
  sync=$(kubectl --context "${context}" --namespace argocd get application go-web-app-kind -o jsonpath='{.status.sync.status}' 2>/dev/null || true)
  health=$(kubectl --context "${context}" --namespace argocd get application go-web-app-kind -o jsonpath='{.status.health.status}' 2>/dev/null || true)
  if [[ "${sync}" == "Synced" && "${health}" == "Healthy" ]]; then
    echo "Argo CD application is Synced and Healthy."
    KUBE_CONTEXT="${context}" NAMESPACE="${namespace}" "${repo_root}/scripts/verify-kind.sh"
    exit 0
  fi
  sleep 3
done

kubectl --context "${context}" --namespace argocd get application go-web-app-kind -o yaml
exit 1
