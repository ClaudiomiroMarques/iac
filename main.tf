terraform {
  required_providers{
      digitalocean = {
          source = "digitalocean/digitalocean"
          version = "~> 2.0"
      }
  }
}

provider "digitalocean" {
    token = var.do_token
    # "dop_v1_828778fe5c26268103ab173bfb26a05457576e0d7eb8830e7e08abc8878f3b57"
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name   = var.k8s_name
  # "k8s-iniciativa-devops"
  region = var.region
  # "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.22.8-do.1"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-4gb"
    node_count = 2 
  }
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_iniciativa.id

  name       = "premium"
  size       = "s-4vcpu-8gb"
  node_count = 2  
  }

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
}
  
resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
    filename = "kube_config.yaml"
}

  


