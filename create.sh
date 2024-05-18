#!/usr/bin/env bash
set -eu -o pipefail

while getopts u:p:s: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) pass=${OPTARG};;
        s) storage=${OPTARG};;
    esac
done

terraform apply -auto-approve

IP="$(terraform output -raw minecraft_server_ip)"

echo -e "\nWaiting for server to boot ..."
sleep 20

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u root \
  --extra-vars "ext_storage=$storage user=$username pass=$pass" \
  ansible/create-minecraft.yml

