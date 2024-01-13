resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}
resource "kubernetes_secret" "dashboard_certs" {
  metadata {
    name      = "kubernetes-dashboard-certs"
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }

  type = "Opaque"
}

resource "kubernetes_service_account" "dashboard" {
  metadata {
    name      = "dashboard-admin"
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "dashboard" {
  metadata {
    name = "dashboard-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.dashboard.metadata[0].name
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }
}
resource "kubernetes_secret" "dashboard_csrf" {
  metadata {
    name      = "kubernetes-dashboard-csrf"
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }

  type = "Opaque"
}

resource "kubernetes_deployment" "dashboard" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.dashboard.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "kubernetes-dashboard"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "kubernetes-dashboard"
        }
      }

      spec {
        container {
          image = "kubernetesui/dashboard:latest"
          name  = "kubernetes-dashboard"

          args = [
            "--auto-generate-certificates",
            "--namespace=kubernetes-dashboard",
          ]

          port {
            container_port = 8443
          }

          volume_mount {
            mount_path = "/certs"
            name       = "kubernetes-dashboard-certs"
          }
        }

        volume {
          name = "kubernetes-dashboard-certs"

          secret {
            secret_name = "kubernetes-dashboard-certs"
          }
        }

        service_account_name = kubernetes_service_account.dashboard.metadata[0].name
      }
    }
  }
}
