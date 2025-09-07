# Makefile

# Terraform directories
MINIKUBE_DIR := infra/local/minikube
NAMESPACE_DIR := infra/local/namespaces

# Default target
.PHONY: apply
apply: minikube namespaces argocd staging-argo-app prod-argo-app
	@echo "=== All resources have been applied ==="

# Step 1: Provision Minikube
.PHONY: minikube
minikube:
	@echo "=== Starting Minikube ==="
	cd $(MINIKUBE_DIR) && terraform init
	cd $(MINIKUBE_DIR) && terraform apply -auto-approve

.PHONY: argocd
argocd:
	@echo "=== Setting up ArgoCD ==="
	helm upgrade --install argocd helm/argo-cd --namespace argocd


.PHONY: staging-argo-app
staging-argo-app:
	@echo "=== Deploying Staging ArgoApp ==="
	kubectl apply -f app/staging/argo-app.yaml

.PHONY: prod-argo-app
prod-argo-app:
	@echo "=== Deploying Prod ArgoApp ==="
	kubectl apply -f app/prod/argo-app.yaml

# Step 2: Provision Kubernetes resources (namespaces, etc.)
.PHONY: namespaces
namespaces:
	@echo "=== Applying Kubernetes resources ==="
	cd $(NAMESPACE_DIR) && terraform init
	cd $(NAMESPACE_DIR) && terraform apply -auto-approve

# Optional: destroy everything
.PHONY: destroy
destroy:
	@echo "=== Destroying Kubernetes resources ==="
	cd $(NAMESPACE_DIR) && terraform destroy -auto-approve
	@echo "=== Destroying Minikube ==="
	cd $(MINIKUBE_DIR) && terraform destroy -auto-approve
