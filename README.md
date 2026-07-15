# Go Web App — End-to-End DevOps Project

[![CI/CD](https://github.com/rkjas112/go-web-app-devops/actions/workflows/cicd.yaml/badge.svg)](https://github.com/rkjas112/go-web-app-devops/actions/workflows/cicd.yaml)

This fork implements the complete learning path from Abhishek Veeramalla's
[DevOpsified project video](https://www.youtube.com/watch?v=HGu9sgoHaJ0):

- Multi-stage, non-root Docker image
- Kubernetes manifests and a reusable Helm chart
- Separate Kind and EKS environment values
- GitHub Actions CI, Docker Hub publishing, and GitOps tag updates
- Argo CD continuous delivery
- ingress-nginx exposure and DNS preparation
- Reproducible EKS creation and guarded cleanup

The original repositories are
[go-web-app](https://github.com/iam-veeramalla/go-web-app) and
[go-web-app-devops](https://github.com/iam-veeramalla/go-web-app-devops).

## Architecture

```text
Developer push
     |
     v
GitHub Actions ── test / lint / Helm validation / image build
     |
     +── Docker Hub image (when publishing is enabled)
     |
     +── update values-eks.yaml with the immutable commit tag
                              |
                              v
                         Argo CD sync
                              |
                    Kubernetes (Kind or EKS)
                              |
                    ingress-nginx -> application
```

## Quick start on the existing Kind cluster

```bash
make check
make helm-lint
make helm-render
make kind-deploy
```

`make kind-deploy` builds and tests the application inside Docker, loads the
image into `cka-cluster2`, deploys the Helm release, waits for readiness, and
checks `/healthz` and `/home` through a temporary port-forward.

After the commit is available on GitHub, hand the release to the existing Argo
CD installation:

```bash
make kind-argocd
```

## Environments

| Environment | Values file | Namespace | Image source |
|---|---|---|---|
| Kind | `helm/go-web-app-chart/values-kind.yaml` | `go-web-app-kind` | Image loaded directly into Kind |
| EKS | `helm/go-web-app-chart/values-eks.yaml` | `go-web-app-prod` | Docker Hub immutable commit tag |

## Project guides

- [Local Kind and Argo CD](docs/01-local-kind.md)
- [GitHub Actions and Docker Hub](docs/02-github-cicd.md)
- [EKS, ingress, DNS, and cleanup](docs/03-eks-dns.md)

## Repository layout

```text
.
├── .github/workflows/       CI/CD pipeline
├── docs/                    Step-by-step project guides
├── eks/                     eksctl cluster configuration
├── gitops/applications/     Argo CD Application resources
├── helm/go-web-app-chart/   Multi-environment Helm chart
├── k8s/manifests/           Raw Kubernetes/Kustomize learning path
├── scripts/                 Repeatable local and AWS operations
├── Dockerfile               Tested multi-stage non-root image
├── Makefile                 Short project commands
└── main.go                  Go HTTP application with health endpoint
```

## Cost safety

Kind work is local. EKS, worker nodes, and AWS load balancers are billable. The
EKS scripts refuse to create or delete the cluster unless an explicit
confirmation environment variable is supplied. Always run the cleanup command
in the EKS guide when the cloud demonstration is finished.
