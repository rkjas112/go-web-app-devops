# DevOps implementation notes

This project starts with a small Go `net/http` application and implements an
end-to-end CI/CD and GitOps workflow.

## Containerization

The Dockerfile uses three logical stages:

1. Run the Go unit tests.
2. Compile a static binary for the target platform.
3. Copy only the binary and static pages into a distroless, non-root runtime.

This keeps the runtime image small and removes compilers, shells, and package
managers from the deployed container.

## Kubernetes

Two deployment approaches are included:

- `k8s/manifests` demonstrates the Deployment, Service, Ingress, namespace, and
  Kustomize image override directly.
- `helm/go-web-app-chart` packages the same resources as a parameterized chart
  with health probes, resource limits, and security contexts.

The Kind and EKS values files keep local and cloud settings separate.

## Continuous integration

GitHub Actions runs unit tests, `go vet`, `golangci-lint`, Helm lint/render
checks, and a Docker build on pushes and pull requests. Image publishing is
disabled until the Docker Hub secrets and `ENABLE_DOCKERHUB_PUSH` repository
variable are configured.

## Continuous delivery

After CI publishes an image, it commits the immutable Git commit tag to the EKS
values file. Argo CD watches the repository, detects that GitOps change, and
reconciles the EKS namespace automatically.

For detailed commands, use the guides in the `docs` directory.
