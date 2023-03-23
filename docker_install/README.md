# docker_install

Provisions an existing host with Debian or Ubuntu OS to install docker engine through SSH.

## Example

```tf
module "docker_install" {
  # Available inputs: https://github.com/futurice/terraform-utils/tree/master/docker_compose_host#inputs
  # Check for updates: https://github.com/futurice/terraform-utils/compare/v11.0...master
  source = "git::https://github.com/dj-thd2/terraform-misc-modules.git//docker_compose_host?ref=master"

  public_ip          = "${digitalocean_droplet.test-droplet.ipv4_address}"
  ssh_username       = "root"
  ssh_private_key    = local.ssh_private_key
}
```

<!-- terraform-docs:begin -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| public_ip | Host public IP with a reachable SSH server | string | n/a | yes |
| ssh_username | SSH username | string | `"root"` | no |
| ssh_private_key | SSH private key | string | n/a | yes | 
| docker_compose_version | Version of docker-compose to install during provisioning (see https://github.com/docker/compose/releases) | string | `"v2.16.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| reprovision_trigger | Hash of all configuration used for this host; can be used as the `reprovision_trigger` input to another module |
| public_ip | Used host public IP with a reachable SSH server |
| ssh_username | Used SSH username |
| ssh_private_key | Used SSH private key |
| docker_compose_version | Used version of docker-compose to install during provisioning (see https://github.com/docker/compose/releases) |
<!-- terraform-docs:end -->
