#!/bin/bash
sudo mkdir -p /etc/needrestart
sudo touch /etc/needrestart/needrestart.conf
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt-get -o DPkg::Lock::Timeout=-1 update
export DEBIAN_FRONTEND=noninteractive; sudo apt-get -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o DPkg::Lock::Timeout=-1 -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install ca-certificates curl gnupg lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/`lsb_release -i -s | tr '[:upper:]' '[:lower:]'`/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/`lsb_release -i -s | tr '[:upper:]' '[:lower:]'` $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -o DPkg::Lock::Timeout=-1 update
export DEBIAN_FRONTEND=noninteractive; sudo apt-get -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o DPkg::Lock::Timeout=-1 -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl restart docker

