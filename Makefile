SHELL := /bin/bash

KIND_CLUSTER ?= cka-cluster2
KUBE_CONTEXT ?= kind-$(KIND_CLUSTER)
NAMESPACE ?= go-web-app-kind
IMAGE ?= go-web-app
TAG ?= dev

.PHONY: check helm-lint helm-render image kind-load kind-deploy kind-verify kind-ingress-verify kind-argocd eks-create eks-bootstrap eks-delete

check:
	./scripts/check-prerequisites.sh

helm-lint:
	helm lint helm/go-web-app-chart -f helm/go-web-app-chart/values-kind.yaml
	helm lint helm/go-web-app-chart -f helm/go-web-app-chart/values-eks.yaml

helm-render:
	helm template go-web-app helm/go-web-app-chart -f helm/go-web-app-chart/values-kind.yaml >/dev/null
	helm template go-web-app helm/go-web-app-chart -f helm/go-web-app-chart/values-eks.yaml >/dev/null

image:
	docker build --tag $(IMAGE):$(TAG) .

kind-load: image
	kind load docker-image $(IMAGE):$(TAG) --name $(KIND_CLUSTER)

kind-deploy:
	KIND_CLUSTER=$(KIND_CLUSTER) KUBE_CONTEXT=$(KUBE_CONTEXT) NAMESPACE=$(NAMESPACE) IMAGE=$(IMAGE) TAG=$(TAG) ./scripts/deploy-kind.sh

kind-verify:
	KUBE_CONTEXT=$(KUBE_CONTEXT) NAMESPACE=$(NAMESPACE) ./scripts/verify-kind.sh

kind-ingress-verify:
	KUBE_CONTEXT=$(KUBE_CONTEXT) ./scripts/verify-kind-ingress.sh

kind-argocd:
	KIND_CLUSTER=$(KIND_CLUSTER) KUBE_CONTEXT=$(KUBE_CONTEXT) NAMESPACE=$(NAMESPACE) IMAGE=$(IMAGE) TAG=$(TAG) ./scripts/enable-argocd-kind.sh

eks-create:
	./scripts/create-eks.sh

eks-bootstrap:
	./scripts/bootstrap-eks.sh

eks-delete:
	./scripts/delete-eks.sh
