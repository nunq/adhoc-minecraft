#!/usr/bin/env bash
set -eu -o pipefail

while getopts s:u:p: flag
do
    case "${flag}" in
        s) storage=${OPTARG};;
        u) username=${OPTARG};;
        p) pass=${OPTARG};;
    esac
done

# Check if variables are set
: ${storage:?Missing -s}
: ${username:?Missing -u}
: ${pass:?Missing -p}

IP="$(terraform output -raw minecraft_server_ip)"

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u minecraft \
  --extra-vars "ext_storage=$storage user=$username pass=$pass" \
  ansible/destroy-minecraft.yml

terraform destroy -auto-approve

echo -e "\nRemoving $IP from known_hosts"
ssh-keygen -R "$IP" || true

rm ./ssh.sh || true
