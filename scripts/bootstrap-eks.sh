#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cluster_name="${EKS_CLUSTER_NAME:-go-web-app-eks}"
region="${AWS_REGION:-ap-south-1}"
context="${KUBE_CONTEXT:-go-web-app-eks}"

cd "${repo_root}"

if grep -Eq 'your-dockerhub-username|example\.com' helm/go-web-app-chart/values-eks.yaml; then
  echo "Update the Docker Hub repository and DNS host in helm/go-web-app-chart/values-eks.yaml first."
  exit 1
fi

aws eks update-kubeconfig --name "${cluster_name}" --region "${region}" --alias "${context}"

kubectl --context "${context}" apply -f \
  https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.15.1/deploy/static/provider/aws/deploy.yaml
kubectl --context "${context}" --namespace ingress-nginx \
  rollout status deployment/ingress-nginx-controller --timeout=300s

kubectl --context "${context}" create namespace argocd --dry-run=client -o yaml | \
  kubectl --context "${context}" apply -f -
kubectl --context "${context}" --namespace argocd apply -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/v3.4.5/manifests/install.yaml
kubectl --context "${context}" --namespace argocd \
  rollout status deployment/argocd-server --timeout=300s

kubectl --context "${context}" apply -f gitops/applications/go-web-app-eks.yaml

echo "Ingress load balancer address:"
kubectl --context "${context}" --namespace ingress-nginx \
  get service ingress-nginx-controller \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}'
