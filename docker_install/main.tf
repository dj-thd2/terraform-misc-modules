resource "null_resource" "provisioners" {
  triggers = {
    public_ip      = "${var.public_ip}"                        # whenever the docker host on which docker-compose runs changes, re-run the provisioners
    reprovision_trigger = "${sha1("${local.reprovision_trigger}")}" # whenever the docker-compose config, environment etc changes, re-run the provisioners
    ssh_username = "${var.ssh_username}"
    ssh_private_key = "${var.ssh_private_key}"
    docker_compose_version = "${var.docker_compose_version}"
  }

  connection {
    host        = "${self.triggers.public_ip}"
    user        = "${self.triggers.ssh_username}"
    private_key = "${self.triggers.ssh_private_key}"
    agent       = false
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/install_docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo curl -SL https://github.com/docker/compose/releases/download/${self.triggers.docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo usermod -a -G docker ${self.triggers.ssh_username}"
    ]
  }
}
