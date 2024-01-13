resource "kubernetes_service" "dashboard" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }

  spec {
    selector = {
      k8s-app = "kubernetes-dashboard"
    }

    port {
      port        = 443
      target_port = 8443
    }

    type = "LoadBalancer"
  }
}
provider "kubernetes" {
  config_path = "/home/rst/.kube/config"
}
