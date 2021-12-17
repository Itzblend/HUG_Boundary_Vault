#!/bin/bash
sudo apt upgrade
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y && sudo apt-get install -y vault
export VAULT_ADDR=http://192.168.56.3:8200
vault server -dev -dev-listen-address=192.168.56.3:8200 &
export VAULT_TOKEN=$(cat .vault-token)