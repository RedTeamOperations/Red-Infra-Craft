#!/bin/bash

sudo apt update

cd /home/azureuser

sudo apt install -y git 
sudo apt install -y wget
sudo wget https://github.com/gophish/gophish/releases/download/0.7.1/gophish-v0.7.1-linux-64bit.zip
sudo apt install -y unzip
sudo unzip gophish-v0.7.1-linux-64bit.zip  
chmod +x gophish

sudo sh -c 'echo "" > config.json'

echo '{
        "admin_server": {
                "listen_url": "0.0.0.0:3333",
                "use_tls": true,
                "cert_path": "gophish_admin.crt",
                "key_path": "gophish_admin.key"
        },
        "phish_server": {
                "listen_url": "0.0.0.0:80",
                "use_tls": false,
                "cert_path": "example.crt",
                "key_path": "example.key"
        },
        "db_name": "sqlite3",
        "db_path": "gophish.db",
        "migrations_prefix": "db/db_",
        "contact_address": ""
}' | sudo tee config.json > /dev/null

sudo apt install -y sqlite3
sudo sqlite3 gophish.db;