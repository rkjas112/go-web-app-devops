# GitHub Actions and Docker Hub

The project fork is `rkjas112/go-web-app-devops`.

## Pipeline behavior

Every push and pull request runs:

1. Go unit tests and `go vet`.
2. Helm lint and render checks for Kind and EKS.
3. `golangci-lint`.
4. A complete multi-stage container build.

Docker Hub publishing is deliberately disabled until credentials are ready.
When enabled on `main`, CI publishes both the immutable Git SHA tag and
`latest`, then updates `values-eks.yaml`. Argo CD uses that Git change as the
deployment trigger.

## Configure Docker Hub safely

Create a Docker Hub access token with read/write access to the `go-web-app`
repository. Do not commit or paste the token into project files.

Set the two GitHub Actions secrets interactively:

```bash
gh secret set DOCKERHUB_USERNAME --repo rkjas112/go-web-app-devops
gh secret set DOCKERHUB_TOKEN --repo rkjas112/go-web-app-devops
```

After both secrets exist, enable publishing:

```bash
gh variable set ENABLE_DOCKERHUB_PUSH \
  --body true \
  --repo rkjas112/go-web-app-devops
```

The workflow uses GitHub's repository-scoped `GITHUB_TOKEN` for the GitOps
commit, so a separate personal access token named `TOKEN` is not required.

## Observe the pipeline

```bash
gh run list --repo rkjas112/go-web-app-devops
gh run watch --repo rkjas112/go-web-app-devops
```

If publishing is not enabled, the validation jobs still run and the publish/CD
jobs appear as skipped.
