#!/bin/bash
set -ex

mkdir /home/access
cd /home/access

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null

sudo apt update -y


echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo git clone https://github.com/its-a-feature/Mythic
sudo apt-get install -y make

cd /home/access/Mythic
sudo make

sudo /home/access/Mythic/mythic-cli install github https://github.com/MythicC2Profiles/http
sudo /home/access/Mythic/mythic-cli install github https://github.com/MythicAgents/Apollo.git
sudo /home/access/Mythic/mythic-cli start
