terraform {
  required_version = ">= 1.6"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

module "uptime_kuma" {
  source         = "./modules/uptime_kuma"
  project_prefix = var.project_prefix
  http_port      = var.uptime_kuma_port
  image          = var.uptime_kuma_image
  restart        = var.restart_policy
}