# Portainer
## Test it
```sh
docker run \
    -it \
    --rm \
    --name portainer \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /srv/portainer/certs:/certs \
    -v /srv/portainer/data:/data \
    dkraemer/portainer \
        --admin-password-file /data/admin.txt \
        --hide-label hidden=true \
        --host unix:///var/run/docker.sock \
        --ssl
```
## Run it
```sh
docker run \
    -d \
    --name portainer \
    --label hidden=true \
    --restart=unless-stopped \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /srv/portainer/certs:/certs \
    -v /srv/portainer/data:/data \
    dkraemer/portainer \
        --admin-password-file /data/admin.txt \
        --hide-label hidden=true \
        --host unix:///var/run/docker.sock \
        --ssl
```