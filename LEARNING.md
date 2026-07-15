# Beginner DevOps Learning Track

This branch starts from the original Go application and follows the same path
as Abhishek Veeramalla's DevOpsified video. The objective is not merely to own
working files; it is to understand why each layer exists and to be able to
diagnose it when it fails.

## Two branches, two purposes

| Branch | Purpose |
|---|---|
| `learning` | Your hands-on workspace. We add one concept at a time. |
| `main` | Completed reference implementation and troubleshooting answer key. |

Do not copy files from `main` before attempting a lesson. After completing a
checkpoint, we will compare your implementation with the reference and discuss
why they differ.

## Time already saved

The following lab infrastructure is already installed and verified:

- Docker with Colima
- Kind and cluster `cka-cluster2`
- kubectl and context `kind-cka-cluster2`
- Helm
- Argo CD in the Kind cluster
- ingress-nginx in the Kind cluster
- AWS CLI and authenticated AWS account
- eksctl
- Git and authenticated GitHub CLI

You do not need local Go or the Argo CD CLI for this course. Go compilation and
testing will initially happen in containers and GitHub Actions. Argo CD can be
managed through Kubernetes resources and its web interface.

Run the reusable lab check:

```bash
./scripts/lab-status.sh
```

## Mental model

```text
source code
    -> tested application
    -> Docker image
    -> Kubernetes workload
    -> reusable Helm package
    -> GitHub Actions automation
    -> image registry
    -> Argo CD reconciliation
    -> EKS + ingress + public DNS
```

Each arrow is a contract. Our job is to learn what goes into that contract,
what comes out, and how to verify it.

## Course modules

| Module | Topic | You should be able to explain or demonstrate |
|---|---|---|
| 0 | Lab tour | Tool versus service, Docker runtime, Kubernetes context, namespace |
| 1 | Understand the app | Entry point, routes, port, static runtime files, tests |
| 2 | Containerization | Image versus container, layers, multi-stage builds, non-root runtime |
| 3 | Kubernetes manifests | Pod, Deployment, Service, Ingress, probes, resources |
| 4 | Helm | Templates, values, releases, Kind/EKS environment overrides |
| 5 | GitHub Actions | Trigger, runner, job, step, secret, artifact, failure gates |
| 6 | Argo CD | Desired state, sync, health, drift, self-healing, GitOps loop |
| 7 | Ingress | Host routing, controller, Service, local versus cloud load balancer |
| 8 | EKS and DNS | Control plane, nodes, IAM, cost, LoadBalancer, DNS record |
| 9 | End-to-end demo | Trace one commit from source to the public application |

Progress is recorded in [PROGRESS.md](PROGRESS.md).

## How each lesson works

1. Read the short concept explanation.
2. Predict the result of each command before running it.
3. Run the commands yourself.
4. Record answers and surprising output in `notes/`.
5. Ask for help with the exact output when something differs.
6. Complete the checkpoint before moving to the next module.

Begin with [Lesson 0: Lab tour](lessons/00-lab-tour.md).
