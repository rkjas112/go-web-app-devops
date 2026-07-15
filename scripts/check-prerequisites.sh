#!/usr/bin/env bash
set -euo pipefail

required=(git docker kind kubectl helm curl)
optional=(aws eksctl argocd go gh)
missing=0

for tool in "${required[@]}"; do
  if command -v "${tool}" >/dev/null 2>&1; then
    printf 'required  %-10s %s\n' "${tool}" "ok"
  else
    printf 'required  %-10s %s\n' "${tool}" "missing"
    missing=1
  fi
done

for tool in "${optional[@]}"; do
  if command -v "${tool}" >/dev/null 2>&1; then
    printf 'optional  %-10s %s\n' "${tool}" "ok"
  else
    printf 'optional  %-10s %s\n' "${tool}" "not installed"
  fi
done

if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but the engine is not reachable."
  missing=1
fi

context="${KUBE_CONTEXT:-kind-cka-cluster2}"
if ! kubectl --context "${context}" get --raw=/readyz --request-timeout=8s >/dev/null 2>&1; then
  echo "Kubernetes context ${context} is not reachable."
  missing=1
else
  echo "Kubernetes context ${context} is reachable."
fi

exit "${missing}"
