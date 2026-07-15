#!/usr/bin/env bash
set -u

context="${KUBE_CONTEXT:-kind-cka-cluster2}"

echo "Installed clients"
for tool in git docker kind kubectl helm aws eksctl gh; do
  if command -v "${tool}" >/dev/null 2>&1; then
    printf '  %-8s installed\n' "${tool}"
  else
    printf '  %-8s missing\n' "${tool}"
  fi
done

echo
if docker info >/dev/null 2>&1; then
  echo "Docker engine: reachable"
else
  echo "Docker engine: not reachable"
fi

clusters=$(kind get clusters 2>/dev/null || true)
if [[ -n "${clusters}" ]]; then
  echo "Kind clusters:"
  printf '%s\n' "${clusters}" | sed 's/^/  /'
else
  echo "Kind clusters: none detected"
fi

echo "kubectl context: ${context}"
if kubectl --context "${context}" get --raw=/readyz --request-timeout=8s >/dev/null 2>&1; then
  echo "Kubernetes API: reachable"
else
  echo "Kubernetes API: not reachable"
  exit 1
fi

if kubectl --context "${context}" -n argocd get deployment argocd-server >/dev/null 2>&1; then
  echo "Argo CD server: available"
else
  echo "Argo CD server: not detected"
fi

if kubectl --context "${context}" -n ingress-nginx get deployment ingress-nginx-controller >/dev/null 2>&1; then
  echo "ingress-nginx controller: available"
else
  echo "ingress-nginx controller: not detected"
fi

sync=$(kubectl --context "${context}" -n argocd get application go-web-app-kind -o jsonpath='{.status.sync.status}' 2>/dev/null || true)
health=$(kubectl --context "${context}" -n argocd get application go-web-app-kind -o jsonpath='{.status.health.status}' 2>/dev/null || true)
ready=$(kubectl --context "${context}" -n go-web-app-kind get deployment go-web-app -o jsonpath='{.status.readyReplicas}/{.status.replicas}' 2>/dev/null || true)

echo "Reference application: sync=${sync:-unknown} health=${health:-unknown} ready=${ready:-unknown}"
