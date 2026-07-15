# Local Kind and Argo CD

The verified local environment uses:

- Docker through Colima
- Kind cluster `cka-cluster2`
- kubectl context `kind-cka-cluster2`
- An existing Argo CD installation in `argocd`
- An existing ingress-nginx installation in `ingress-nginx`

## Validate prerequisites

```bash
make check
make helm-lint
make helm-render
```

Local Go is not required. Tests run during the Docker build, while GitHub
Actions installs its own Go toolchain.

## Build, load, and deploy with Helm

```bash
make kind-deploy
```

The command creates namespace `go-web-app-kind`, deploys release `go-web-app`,
waits for its Deployment, and performs HTTP checks using a temporary service
port-forward.

Run the verification again at any time:

```bash
make kind-verify
```

## Verify ingress-nginx

The existing Kind cluster does not publish host port 80, so use a port-forward
to test the Ingress resource:

```bash
kubectl --context kind-cka-cluster2 -n ingress-nginx \
  port-forward service/ingress-nginx-controller 18081:80
```

In another terminal:

```bash
curl -H 'Host: go-web-app.local' http://127.0.0.1:18081/healthz
```

## Enable Argo CD management

Argo CD reads the chart from GitHub, so push the prepared commit before this
step. Then run:

```bash
make kind-argocd
```

The script removes only the direct Helm release, applies
`gitops/applications/go-web-app-kind.yaml`, waits for `Synced` and `Healthy`,
and repeats the HTTP checks.

The Kind values add Argo CD's documented `ignore-healthcheck` annotation only
to the local Ingress. A Kind Ingress has no cloud load-balancer status, which
would otherwise keep the Application in `Progressing`; the EKS values retain
the normal load-balancer health evaluation.

To view the Argo CD UI locally:

```bash
kubectl --context kind-cka-cluster2 -n argocd \
  port-forward service/argocd-server 18090:443
```

Open `https://127.0.0.1:18090`. The browser will show a local certificate
warning.
