# Lesson 0 — Tour the reusable lab

Video context: project overview at
[00:05–05:25](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=5s), with tool
prerequisites revisited during Docker, EKS, Helm, and Argo CD setup. This lesson
uses the setup already completed on your machine to avoid repeating installs.

## Goal

Understand the difference between a command-line tool, a running service, and a
remote account before changing application code.

## Tools versus running systems

- `docker` is a client. Colima provides the Docker engine that actually builds
  and runs containers.
- `kind` creates Kubernetes nodes as Docker containers.
- `kubectl` is a client that talks to a selected Kubernetes API server.
- `helm` renders templates and tracks Kubernetes releases.
- Argo CD is running inside Kubernetes; a local `argocd` executable is optional.
- `aws` and `eksctl` call AWS APIs. Having the binaries does not by itself grant
  cloud permissions.
- `gh` is a GitHub client. Git is still responsible for commits and pushes.

## Exercise A — Inspect the lab

From the repository root, predict whether each section will pass, then run:

```bash
./scripts/lab-status.sh
```

The important expected results are:

- Docker engine: reachable
- Kind cluster: `cka-cluster2`
- kubectl context: `kind-cka-cluster2`
- Argo CD server: available
- ingress-nginx controller: available
- reference application: `Synced`, `Healthy`, and one ready replica

## Exercise B — Inspect Kubernetes scope

```bash
kubectl --context kind-cka-cluster2 get nodes
kubectl --context kind-cka-cluster2 get namespaces
kubectl --context kind-cka-cluster2 -n argocd get deployments
kubectl --context kind-cka-cluster2 -n go-web-app-kind get all
```

Notice that the context chooses the cluster while `-n` chooses a namespace
inside that cluster.

## Checkpoint questions

Write answers in `notes/lesson-00-answers.md`:

1. Why can `docker --version` succeed while `docker info` fails?
2. What is the difference between Kind and kubectl?
3. Where is the Argo CD server running?
4. What does a Kubernetes namespace isolate?
5. Why will we use Kind before EKS?

Do not search for perfect definitions. Explain them in your own words. When you
share the answers, we will correct the mental model together.

## Completion rule

Move to Lesson 1 only when you can point to the Docker engine, Kind nodes,
Kubernetes API, Argo CD pods, and application namespace and describe how they
relate.
