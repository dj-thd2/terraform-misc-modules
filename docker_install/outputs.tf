locals {
  reprovision_trigger = <<EOF
  ${var.docker_compose_version}
EOF
}

output "reprovision_trigger" {
  description = "Hash of all docker-compose configuration used for this host; can be used as the `reprovision_trigger` input to an `aws_ec2_ebs_docker_host` module"
  value       = "${sha1("${local.reprovision_trigger}")}"
}

output "public_ip" { 
  value = "${var.public_ip}"
}

output "ssh_username" { 
  value = "${var.ssh_username}"
}

output "ssh_private_key" { 
  value = "${var.ssh_private_key}"
}

output "docker_compose_version" {
  value = "${var.docker_compose_version}"
}

