#!/bin/bash
sudo apt upgrade
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y && sudo apt-get install boundary -y
export BOUNDARY_ADDR=http://192.168.56.2:9200
boundary database init -config /provision/boundary.hcl > /media/boundary_init_db.txt
boundary server -config /provision/boundary.hcl &