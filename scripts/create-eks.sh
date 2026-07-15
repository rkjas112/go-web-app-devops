#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

if [[ "${CONFIRM_EKS_CREATE:-}" != "yes" ]]; then
  echo "This creates billable AWS resources. Re-run with CONFIRM_EKS_CREATE=yes after reviewing eks/cluster.yaml."
  exit 1
fi

aws sts get-caller-identity >/dev/null
eksctl create cluster --config-file "${repo_root}/eks/cluster.yaml"
