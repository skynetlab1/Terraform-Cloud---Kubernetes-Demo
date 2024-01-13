variable "dashboard_domain" {
  description = "The domain for the Kubernetes dashboard"
  type        = string
  default     = "dashboard.example.com"
}

variable "dashboard_namespace" {
  description = "The namespace of the Kubernetes dashboard"
  type        = string
  default     = "kubernetes-dashboard"
}

variable "dashboard_service_name" {
  description = "The name of the Kubernetes dashboard service"
  type        = string
  default     = "kubernetes-dashboard"
}

variable "dashboard_service_port" {
  description = "The port of the Kubernetes dashboard service"
  type        = number
  default     = 443
}
