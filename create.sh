#!/usr/bin/env bash
set -eu -o pipefail

SSH_KEY_PATH="~/.ssh/id_ed25519_adhoc-mc"

while getopts u:p:s: flag
do
  case "${flag}" in
    u) username=${OPTARG};;
    p) pass=${OPTARG};;
    s) storage=${OPTARG};;
  esac
done

# Check if variables are set
: ${storage:?Missing -s}
: ${username:?Missing -u}
: ${pass:?Missing -p}

if [ ! -f "$SSH_KEY_PATH" ]; then
  echo  "Creating ad-hoc minecraft SSH key ..."
  ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N "" -C "adhoc-mc"
fi

terraform apply -auto-approve

IP="$(terraform output -raw minecraft_server_ip)"

echo -e "\nWaiting for server to boot ..."
sleep 20

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u root \
  --extra-vars "ext_storage=$storage user=$username pass=$pass" \
  ansible/create-minecraft.yml

