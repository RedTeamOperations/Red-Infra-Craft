#!/bin/bash

sudo apt update

cd /home/azureuser

sudo apt install -y wget
wget https://github.com/kgretzky/pwndrop/releases/download/1.0.1/pwndrop-linux-amd64.tar.gz
tar zxvf pwndrop-linux-amd64.tar.gz 