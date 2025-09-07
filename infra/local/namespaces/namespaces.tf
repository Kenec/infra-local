provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  namespaces = [
    "internal-dev",
    "internal-staging",
    "internal-prod",
    "external-dev",
    "external-staging",
    "external-prod",
    "argocd",
  ]
}

resource "kubernetes_namespace" "namespaces" {
  for_each = toset(local.namespaces)

  metadata {
    name = each.key
  }
}
