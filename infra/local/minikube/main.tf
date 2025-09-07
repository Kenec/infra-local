resource "null_resource" "minikube" {
  provisioner "local-exec" {
    command = <<EOT
      minikube delete
      minikube start --driver=docker --memory=4096 --cpus=2
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "minikube delete"
  }
}
