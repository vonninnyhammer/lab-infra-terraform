variable "project_prefix" {
  description = "Prefix for all created resources; keeps the IaC footprint collision-free from the pre-existing compose stack."
  type        = string
  default     = "tf"
}

variable "docker_host" {
  description = "Docker daemon endpoint. Defaults to the local socket; set to an ssh:// alias (e.g. ssh://forge-ts) to manage the lab server over the encrypted mesh."
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "uptime_kuma_port" {
  description = "Host port exposed for the uptime dashboard."
  type        = number
  default     = 3003
}

variable "uptime_kuma_image" {
  description = "Image tag for the uptime monitoring service."
  type        = string
  default     = "louislam/uptime-kuma:1"
}

variable "restart_policy" {
  description = "Container restart policy."
  type        = string
  default     = "always"
}