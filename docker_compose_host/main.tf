resource "null_resource" "provisioners" {
  triggers = {
    docker_host_ip      = "${var.public_ip}"                        # whenever the docker host on which docker-compose runs changes, re-run the provisioners
    reprovision_trigger = "${sha1("${local.reprovision_trigger}")}" # whenever the docker-compose config, environment etc changes, re-run the provisioners
    ssh_username = "${var.ssh_username}"
    ssh_private_key = "${var.ssh_private_key}"
    ssh_user_home = "${var.ssh_user_home}"
    docker_compose_version = "${var.docker_compose_version}"
    docker_compose_env = "${var.docker_compose_env}"
    docker_compose_yml = "${var.docker_compose_yml}"
    docker_compose_override_yml = "${var.docker_compose_override_yml}"
    docker_compose_up_command = "${var.docker_compose_up_command}"
    docker_compose_down_command = "${var.docker_compose_down_command}"
  }

  connection {
    host        = "${self.triggers.docker_host_ip}"
    user        = "${self.triggers.ssh_username}"
    private_key = "${self.triggers.ssh_private_key}"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [<<EOF
command -v docker-compose && (docker-compose -v | grep ${self.triggers.docker_compose_version})
if [ "$?" -gt 0 ]; then
  sudo curl -L https://github.com/docker/compose/releases/download/${self.triggers.docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose # https://docs.docker.com/compose/install/
  sudo chmod +x /usr/local/bin/docker-compose
  echo "docker-compose (${self.triggers.docker_compose_version}) installed"
else
  echo "docker-compose (${self.triggers.docker_compose_version}) already installed"
fi
EOF
    ]
  }

  provisioner "file" {
    content     = "${self.triggers.docker_compose_env}"
    destination = "${self.triggers.ssh_user_home}/.env"
  }

  provisioner "file" {
    content     = "${self.triggers.docker_compose_yml}"
    destination = "${self.triggers.ssh_user_home}/docker-compose.yml"
  }

  provisioner "file" {
    content     = "${self.triggers.docker_compose_override_yml}"
    destination = "${self.triggers.ssh_user_home}/docker-compose.override.yml"
  }

  provisioner "remote-exec" {
    inline = ["${self.triggers.docker_compose_up_command}"]
  }

  provisioner "remote-exec" {
    when   = destroy
    inline = ["${self.triggers.docker_compose_down_command}"]
  }
}
