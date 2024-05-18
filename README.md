# ad-hoc minecraft

These scripts automatically provision a server on Hetzner Cloud for playing Minecraft.
Because Minecraft is quite demanding, running such powerful servers 24/7 can get quite expensive,
so this is a way to create/destroy such a server on the fly with the save data being persisted across servers.

I'm using Hetzner's storage boxes to persist my save data but you can use anything that's supported by rsync,
though you might have to tweak the ansible playbooks a bit.

Currently a Hetzner CPX31 is provisioned with 4 vCPUs and 8GB of RAM, you can change this in `main.tf`.

## Setup
* Create a new project in Hetzner Cloud and generate an API key
* Create `terraform.tfvars` with the following content:
    ```hcl
    hcloud_token = "YOUR_PROJECT_API_TOKEN"
    ```
* Create the folder the save data will be synced to on the external storage

## Create
To create the server, just run this:
```bash
./create.sh \
  -s "EXTERNAL STORAGE FOLDER" \
  -u "EXTERNAL STORAGE SSH USER" \
  -p "EXTERNAL STORAGE SSH PASS" \
  -w "USERNAMES ON WHITELIST. COMMA SEPARATED" \
  -o "OP USERNAMES. COMMA SEPARATED" \
  -c "SUDO PASSWORD OF SERVER USER"
```

For example:
```bash
./create.sh \
  -s "user1234.your-storagebox.de:/home/sync/" \
  -u "user1234-sub1" \
  -p "ext_storage_password" \
  -w "bob,alice" \
  -o "alice" \
  -c "super_secret"
```

## Destroy
```bash
./destroy.sh \
  -s "EXTERNAL STORAGE FOLDER" \
  -u "EXTERNAL STORAGE SSH USER" \
  -p "EXTERNAL STORAGE SSH PASS"
```

## On the server
* SSH into the created server by running `./ssh.sh` (provided as a convenience)
* You can attach to the running container using `docker attach minecraft` and detach by pressing `ctrl+p` & `ctrl+q`.
* View logs with `docker logs minecraft`
