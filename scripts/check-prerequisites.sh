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
  if kubectl --context "${context}" --namespace argocd get deployment argocd-server >/dev/null 2>&1; then
    echo "Argo CD server is installed in ${context}."
  else
    echo "Argo CD server was not detected in ${context}."
  fi
  if kubectl --context "${context}" --namespace ingress-nginx get deployment ingress-nginx-controller >/dev/null 2>&1; then
    echo "ingress-nginx is installed in ${context}."
  else
    echo "ingress-nginx was not detected in ${context}."
  fi
fi

exit "${missing}"
