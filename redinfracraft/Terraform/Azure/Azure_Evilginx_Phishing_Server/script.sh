#!/bin/bash

sudo apt update

cd /home/azureuser

sudo apt install -y wget
wget https://golang.org/dl/go1.19.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.19.5.linux-amd64.tar.gz

echo -e "export GOROOT=/usr/local/go" | sudo tee -a .profile
echo -e 'export GOPATH=$HOME/go' | sudo tee -a /home/azureuser/.profile
echo -e 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' | sudo tee -a /home/azureuser/.profile
source .profile

sudo apt-get -y install git make
sudo git clone https://github.com/kgretzky/evilginx2.git


cd /home/azureuser/evilginx2/
sudo /usr/local/go/bin/go build -o /home/azureuser/evilginx2/evilginx2 -ldflags="-s -w -buildid=" -buildvcs=false

sudo hostnamectl set-hostname cwltraining.live

sudo reboot