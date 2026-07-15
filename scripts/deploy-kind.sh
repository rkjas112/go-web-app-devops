#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cluster="${KIND_CLUSTER:-cka-cluster2}"
context="${KUBE_CONTEXT:-kind-${cluster}}"
namespace="${NAMESPACE:-go-web-app-kind}"
image="${IMAGE:-go-web-app}"
tag="${TAG:-dev}"

cd "${repo_root}"

kubectl --context "${context}" get --raw=/readyz --request-timeout=8s >/dev/null
docker build --tag "${image}:${tag}" .
kind load docker-image "${image}:${tag}" --name "${cluster}"

helm lint helm/go-web-app-chart -f helm/go-web-app-chart/values-kind.yaml
helm upgrade --install go-web-app helm/go-web-app-chart \
  --kube-context "${context}" \
  --namespace "${namespace}" \
  --create-namespace \
  --values helm/go-web-app-chart/values-kind.yaml \
  --set-string image.repository="${image}" \
  --set-string image.tag="${tag}" \
  --wait \
  --timeout 3m

kubectl --context "${context}" --namespace "${namespace}" \
  rollout status deployment/go-web-app --timeout=180s

KUBE_CONTEXT="${context}" NAMESPACE="${namespace}" "${repo_root}/scripts/verify-kind.sh"
