#!/usr/bin/env bash

terraform apply -auto-approve

IP="$(terraform output -raw minecraft_server_ip)"

echo -e "\nWaiting for server to boot ..."
sleep 20

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u root \
  ansible/create-minecraft.yml

