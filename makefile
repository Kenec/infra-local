# Makefile

# Terraform directories
MINIKUBE_DIR := infra/local/minikube
NAMESPACE_DIR := infra/local/namespaces

# Default target
.PHONY: apply
apply: minikube namespaces argocd

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

# 	kubectl create namespace argocd || true
# 	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# 	kubectl rollout status deployment argocd-server -n argocd	

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
