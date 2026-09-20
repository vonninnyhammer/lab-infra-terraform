output "container_name" {
  value = docker_container.uptime_kuma.name
}

output "dashboard_url" {
  value = "/"
  description = "Root path of the uptime dashboard; port exposed on the host."
}

output "network_name" {
  value = docker_network.edge.name
}