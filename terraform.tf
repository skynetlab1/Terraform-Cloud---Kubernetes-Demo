terraform {
  cloud {
    organization = "expertpcin"

    workspaces {
      name = "mtc-k8s"
    }
  }
}
