#!/usr/bin/env bash
# rsync data to cloud storage
#
IP="$(terraform output -raw minecraft_server_ip)"

terraform destroy -auto-approve

echo "\nRemoving $IP from known_hosts"
ssh-keygen -R "$IP" || true

