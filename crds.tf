resource "null_resource" "apply_manifest" {
  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v0.5.0/standard-install.yaml &&
      helm repo add apisix https://charts.apiseven.com &&
      helm install apisix/apisix --generate-name
    EOF
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
