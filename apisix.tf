provider "helm" {
  kubernetes {
    config_path = "/home/rst/.kube/config"
  }
}
resource "helm_release" "apisix" {
  name       = "apisix"
  repository = "https://charts.apiseven.com"
  chart      = "apisix"
  namespace  = "ingress-apisix"

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingress-controller.enabled"
    value = "true"
  }

  set {
    name  = "ingress-controller.config.apisix.serviceNamespace"
    value = "ingress-apisix"
  }

  set {
    name  = "ingress-controller.config.apisix.adminAPIVersion"
    value = "v3"
  }
}
resource "kubernetes_manifest" "dashboard_route" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1alpha2"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "dashboard-route"
      "namespace" = var.dashboard_namespace
    }
    "spec" = {
      "hostnames" = [var.dashboard_domain]
      "rules" = [
        {
          "matches" = [
            {
              "path" = {
                "type"  = "PathPrefix"
                "value" = "/"
              }
            }
          ]
          "backendRefs" = [
            {
              "name" = var.dashboard_service_name
              "port" = var.dashboard_service_port
            }
          ]
        }
      ]
    }
  }
}
