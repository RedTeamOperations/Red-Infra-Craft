#!/bin/bash

sudo mkdir -p /home/azureuser/access
cd /home/azureuser/access

sudo apt-get update -y
sudo apt-get install -y git

sudo git clone https://github.com/its-a-feature/Mythic

cd /home/azureuser/access/Mythic

sudo apt install -y ca-certificates curl gnupg

# Create the keyrings directory (if not already created)
sudo mkdir -p /etc/apt/keyrings

# Download and add the Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo apt-get install -y make
sudo make

sudo /home/azureuser/access/Mythic/mythic-cli install github https://github.com/MythicC2Profiles/http
sudo -E /home/azureuser/access/Mythic/mythic-cli install github https://github.com/MythicAgents/Apollo.git

sudo /home/azureuser/access/Mythic/mythic-cli start
