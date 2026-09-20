terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "edge" {
  name = "${var.project_prefix}-edge"
}

resource "docker_volume" "kuma_data" {
  name = "${var.project_prefix}-kuma-data"
}

resource "docker_container" "uptime_kuma" {
  name    = "${var.project_prefix}-uptime-kuma"
  image   = docker_image.uptime_kuma.image_id
  restart = var.restart

  ports {
    internal = 3001
    external = var.http_port
  }

  volumes {
    volume_name    = docker_volume.kuma_data.name
    container_path = "/app/data"
  }

  networks_advanced {
    name = docker_network.edge.name
  }
}

resource "docker_image" "uptime_kuma" {
  name = var.image
}