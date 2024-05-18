#!/usr/bin/env bash
set -eu -o pipefail

SSH_KEY_PATH="/home/$USER/.ssh/id_ed25519_adhoc-mc"

while getopts u:p:s:w:o:c: flag
do
  case "${flag}" in
    u) username=${OPTARG};;
    p) pass=${OPTARG};;
    s) storage=${OPTARG};;
    w) whitelist=${OPTARG};;
    o) ops=${OPTARG};;
    c) user_cred=${OPTARG};;
  esac
done

# Check if variables are set
: ${username:?Missing -u}
: ${pass:?Missing -p}
: ${storage:?Missing -s}
: ${whitelist:?Missing -w}
: ${ops:?Missing -o}
: ${user_cred:?Missing -c}

if [ ! -f "$SSH_KEY_PATH" ]; then
  echo  "Creating ad-hoc minecraft SSH key ..."
  ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N "" -C "adhoc-mc"
fi

terraform apply -auto-approve

IP="$(terraform output -raw minecraft_server_ip)"
PW_HASH="$(openssl passwd -6 $user_cred)"

echo "ssh minecraft@$IP -i $SSH_KEY_PATH" > ./ssh.sh
chmod +x ./ssh.sh

echo -e "\nWaiting for server to boot (20 sec) ..."
sleep 20

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u root \
  --extra-vars "ext_storage=$storage user=$username pass=$pass whitelist=$whitelist ops=$ops pw_hash=$PW_HASH" \
  ansible/create-minecraft.yml

echo "Server is ready!"
echo "ssh into the server by running ./ssh.sh"
echo -e "\nMinecraft Server IP: $IP"

