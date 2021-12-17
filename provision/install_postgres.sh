#!/bin/bash

sudo apt update -y
sudo apt -y upgrade
sudo apt install -y postgresql postgresql-client
sudo -u postgres psql -c "CREATE DATABASE boundary"
sudo -u postgres psql -c "ALTER USER postgres password 'postgres'"
sudo echo "host all all all password" >> /etc/postgresql/12/main/pg_hba.conf
sudo echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf
sudo systemctl restart postgresql@12-main.service