variable "public_ip" {
  description = "Public IP address of a host running docker"
}

variable "ssh_username" {
  description = "SSH username, which can be used for provisioning the host"
  default     = "ubuntu"                                                    # to match the corresponding default in aws_ec2_ebs_docker_host
}

variable "ssh_private_key" {
  description = "SSH private key, which can be used for provisioning the host"
}

variable "docker_compose_version" {
  description = "Version of docker-compose to install during provisioning (see https://github.com/docker/compose/releases)"
  default     = "v2.16.0"
}

