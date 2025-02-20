#!/usr/bin/env bash
set -eu -o pipefail

# load config vals
source ./secrets.sh

IP="$(terraform output -raw minecraft_server_ip)"

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u minecraft \
  --extra-vars "ext_storage=$REMOTE_STORAGE_URL user=$REMOTE_STORAGE_USER pass=$REMOTE_STORAGE_PASS" \
  ansible/destroy-minecraft.yml

terraform destroy -auto-approve

echo -e "\nRemoving $IP from known_hosts"
ssh-keygen -R "$IP" || true

rm ./ssh.sh || true
