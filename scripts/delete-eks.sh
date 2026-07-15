#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

if [[ "${CONFIRM_EKS_DELETE:-}" != "yes" ]]; then
  echo "Re-run with CONFIRM_EKS_DELETE=yes to delete the project EKS cluster and stop its cluster charges."
  exit 1
fi

eksctl delete cluster --config-file "${repo_root}/eks/cluster.yaml" --wait
