#!/bin/bash
set -o nounset
set -o errexit

portainer_root_dir="/srv/portainer"
portainer_certs_dir="${portainer_root_dir}/certs"
portainer_data_dir="${portainer_root_dir}/data"

mkdir -pv "${portainer_root_dir}" "${portainer_certs_dir}" "${portainer_data_dir}"
chmod -Rv 0700 "${portainer_root_dir}"

echo "------------------------------------------------"
echo "Please upload portainer.crt and portainer.key to \"${portainer_certs_dir}\" now."
echo "Press ENTER to continue..."
read
chmod -v 0600 "${portainer_certs_dir}/portainer.key"
echo "------------------------------------------------"
echo "Please upload admin.txt to \"${portainer_data_dir}\" now."
echo "Press ENTER to continue..."
read
chmod -v 0600 "${portainer_data_dir}/admin.txt"

docker run \
    -d \
    --name portainer \
    --label hidden=true \
    --restart=unless-stopped \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${portainer_certs_dir}":/certs \
    -v "${portainer_data_dir}":/data \
    dkraemer/portainer \
        --admin-password-file /data/admin.txt \
        --hide-label hidden=true \
        --host unix:///var/run/docker.sock \
        --ssl
