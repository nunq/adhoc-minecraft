#!/usr/bin/env bash
set -eu -o pipefail

SSH_KEY_PATH="/home/$USER/.ssh/id_ed25519_adhoc-mc"

# load config vals
source ./secrets.sh

if [ ! -f "$SSH_KEY_PATH" ]; then
  echo  "Creating ad-hoc minecraft SSH key ..."
  ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N "" -C "adhoc-mc"
fi

terraform apply -auto-approve

IP="$(terraform output -raw minecraft_server_ip)"
PW_HASH="$(openssl passwd -6 $SERVER_NONROOT_USER_PASS)"

echo -e "#!/usr/bin/env bash\nssh minecraft@$IP -i $SSH_KEY_PATH" > ./ssh.sh
chmod +x ./ssh.sh

echo -e "\nWaiting for server to boot (20 sec) ..."
sleep 20

ansible-playbook -i "$IP," \
  --private-key ~/.ssh/id_ed25519_adhoc-mc \
  -u root \
  --extra-vars "ext_storage=$REMOTE_STORAGE_URL user=$REMOTE_STORAGE_USER pass=$REMOTE_STORAGE_PASS whitelist=$MC_WHITELIST ops=$MC_OPS pw_hash=$PW_HASH world_name=$MC_WORLD_NAME" \
  ansible/create-minecraft.yml

echo "Server is ready!"
echo "ssh into the server by running ./ssh.sh"
echo -e "\nMinecraft Server IP: $IP"

