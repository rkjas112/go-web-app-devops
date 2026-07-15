# Video-to-repository map

This guide maps Abhishek Veeramalla's
[DevOpsified project video](https://www.youtube.com/watch?v=HGu9sgoHaJ0)
to this repository. The timestamps were verified against the transcript supplied
with the course.

## How the repositories and branches relate

| Location | Role in the course |
|---|---|
| `app-source/main` | Original `iam-veeramalla/go-web-app` application—the developer team's starting point. |
| `upstream/main` | Original `iam-veeramalla/go-web-app-devops` reference repository. |
| `origin/learning` | Your hands-on branch. Build each layer here while watching the matching segment. |
| `origin/main` | Our completed, tested answer key with current tooling and safer defaults. |

Use `git show main:<path>` to inspect an answer-key file without leaving the
learning branch. For example:

```bash
git show main:Dockerfile
```

Try the lesson first; compare with `main` after reaching the checkpoint.

## Timestamp map

| Video | Topic and learning checkpoint | Repository mapping |
|---|---|---|
| [00:05](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=5s)–05:25 | Project overview: containerization, Kubernetes, CI, GitOps CD, EKS, Helm, ingress, and DNS. Draw the complete delivery flow before building it. | `LEARNING.md`; completed overview in `main:README-DevOps.md` |
| [05:25](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=325s)–09:50 | Understand and run the application before containerizing it: build command, port `8080`, routes, and static files. | `lessons/01-understand-the-app.md`, `main.go`, `main_test.go`, `static/` |
| [09:50](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=590s)–19:52 | Write the multi-stage Dockerfile. Understand the builder image, dependency download, binary, static content, distroless runtime, exposed port, and command. | `main:Dockerfile`, `main:.dockerignore` |
| [19:52](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=1192s)–24:30 | Build and run the image, fix the Go-version mismatch, map host/container ports, and verify `/courses`. | Docker lesson; reference commands in `main:Makefile` and `main:docs/01-local-kind.md` |
| [24:30](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=1470s)–25:49 | Push the container image to a registry so Kubernetes can pull it. | `main:.github/workflows/cicd.yaml`; Docker Hub publishing remains optional until credentials are configured |
| [25:49](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=1549s)–35:35 | Create Deployment, Service, and Ingress manifests. Focus on labels/selectors, replicas, image, container port, Service target port, host, and ingress class. | `main:k8s/manifests/deployment.yaml`, `service.yaml`, `ingress.yaml`, `namespace.yaml`, `kustomization.yaml` |
| [35:35](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=2135s)–41:13 | EKS prerequisites, AWS authentication, IAM warning, and `eksctl` cluster creation. | `main:eks/01-prereq.md`, `main:eks/cluster.yaml`, `main:scripts/create-eks.sh`, `main:scripts/delete-eks.sh` |
| [41:13](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=2473s)–46:06 | Apply and validate the Deployment, Service, and Ingress; temporarily test through NodePort. | First practise on Kind; `main:scripts/deploy-kind.sh`, `main:scripts/verify-kind.sh` |
| [46:06](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=2766s)–58:49 | Install ingress-nginx, understand Ingress vs controller vs cloud load balancer, inspect ingress class, and map the host locally. | `main:ingress-controller/nginx/01-installation.md`, `main:scripts/verify-kind-ingress.sh`, `main:docs/03-eks-dns.md` |
| [58:49](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=3529s)–1:03:03 | Why Helm is needed, `helm create`, and the roles of `Chart.yaml`, `templates/`, and `values.yaml`. | `main:helm/go-web-app-chart/Chart.yaml`, `.helmignore`, `values.yaml` |
| [1:03:03](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=3783s)–1:10:15 | Move manifests into templates, parameterize the image tag, install, inspect, and uninstall the release. | `main:helm/go-web-app-chart/templates/`, `values-kind.yaml`, `values-eks.yaml` |
| [1:10:15](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=4215s)–1:15:13 | CI/CD mental model: build/test, static analysis, image build/push, update Helm, then let Argo CD reconcile Git to Kubernetes. | `main:README-DevOps.md`, `main:.github/workflows/cicd.yaml`, `main:gitops/applications/` |
| [1:15:13](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=4513s)–1:22:25 | Create the GitHub Actions workflow, trigger it on a push, use runners, build/test, and run static analysis. | `main:.github/workflows/cicd.yaml`, `main:docs/02-github-cicd.md` |
| [1:22:25](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=4945s)–1:31:34 | Build/push the image, configure Docker Hub credentials, use a unique tag, update Helm values, and commit the change. | Same workflow; repository secrets `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`, plus variable `ENABLE_DOCKERHUB_PUSH` |
| [1:31:34](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=5494s)–1:34:34 | Run and verify the CI jobs, registry image, unique tag, and updated Helm values. | GitHub Actions on `origin/main`; `main:helm/go-web-app-chart/values-eks.yaml` |
| [1:34:34](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=5674s)–1:39:07 | Install and access Argo CD; understand its namespace, Service, and initial credentials. | Argo CD is already installed in Kind; `main:gitops/argocd/01-install.md` |
| [1:39:07](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=5947s)–1:42:29 | Create the Argo CD application, choose automatic sync and self-heal, connect the repository/Helm path, and verify resources. | `main:gitops/applications/go-web-app-kind.yaml`, `go-web-app-eks.yaml`, `main:scripts/enable-argocd-kind.sh` |
| [1:42:29](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=6149s)–1:46:41 | End-to-end demonstration: change HTML, trigger CI, publish a new image/tag, update Helm, let Argo CD deploy, and verify the page. | Final course checkpoint; trace GitHub Actions, Git commit, Argo CD Application, Deployment image, and HTTP response |
| [1:46:41](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=6401s)–1:47:37 | Recap the entire DevOps implementation. Explain it without reading the YAML. | `PROGRESS.md` module 9 completion rule |

## Important differences from the video

The concepts and flow are the same, but `main` is intentionally not a
byte-for-byte copy of the older demonstration:

- The video creates `k8s/manifest`; our reference uses `k8s/manifests` and adds
  a Namespace and Kustomization file.
- The reference Dockerfile uses a current Go builder and a non-root distroless
  runtime, and it runs tests during the build.
- The video mainly parameterizes the image tag in Helm. Our chart also supports
  Kind and EKS values, probes, resources, and security contexts.
- The video creates the Argo CD Application through the UI. We store the
  Application as YAML so GitOps configuration is reproducible.
- The video uses a separately created GitHub personal access token. Our workflow
  uses the scoped built-in `GITHUB_TOKEN` for repository updates.
- Docker Hub publishing is guarded until you add your credentials. No secret is
  stored in Git.
- EKS creation and deletion are guarded because they create billable AWS
  resources. Kind is used first to learn and debug the same Kubernetes objects
  without cloud cost.

These differences will be explained at the relevant timestamp; they are useful
examples of how a tutorial implementation evolves into a safer current project.
