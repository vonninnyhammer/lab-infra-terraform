# Lab infrastructure as code (Terraform)

Infrastructure-as-code for a self-hosted lab server — an aging 2013-era Xeon
box ("the Forge") that runs the whole homelab under real constraints:
**no public IP, no open inbound ports, managed exclusively over an encrypted
mesh (Tailscale), with CPU-only inference throughout.**

This repo turns a slice of that lab into executable, version-controlled state.

## Scope, honestly

Terraform is not a hammer for every nail. The Forge already runs a large,
healthy stack under docker compose (anythingllm, qdrant, openviking, honcho,
searxng, navidrome, caddy). Terraform deliberately owns only a **small,
additive footprint** — the pieces that benefit from a reproducible lifecycle:

- a dedicated `tf-edge` docker network,
- a named volume for stateful data,
- the uptime monitoring service (a single container, image pinned, port
  configurable),

all namespaced with a `tf-` prefix so nothing collides with the compose-managed
stack. The existing containers stay untouched by `apply` / `destroy`.

Why this boundary? IaC pays off where you want a rebuildable, repeatable
lifecycle; it adds pointless churn to low-turnover experiments. Choosing that
boundary is part of the engineering.

## Layout

```
main.tf                     provider + terraform block, module wiring
variables.tf                tunables (docker endpoint, port, image)
modules/uptime_kuma/        self-contained module: network + volume + container
terraform.tfvars.example    template for local values (never commit the real one)
.gitignore                  state, plan files, and .tfvars stay untracked
```

## Prerequisites

- Terraform >= 1.6
- a reachable Docker daemon. For a remote lab server the endpoint is an
  `ssh://` alias defined in `~/.ssh/config` (over the Tailscale mesh), e.g.
  `ssh://forge-ts`.

## Quickstart

```console
cp terraform.tfvars.example terraform.tfvars   # set docker_host
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` and the `*.tfstate` files are gitignored by design; the
real endpoint and any state details never enter the repository.

## Destroy

`terraform destroy` removes only the resources Terraform owns (the `tf-`
prefixed network, volume, and monitoring container). Verify with:

```console
docker ps --filter "name=^tf-"
```

## Roadmap

- manage the edge DNS/tunnel tier (Cloudflare provider) as code,
- wire the mesh ACLs (Tailscale provider),
- a `kind` cluster on the Forge, then the Kubernetes provider for the
  document/OCR services already running on this stack.