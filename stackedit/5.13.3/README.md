# Stackedit
## Test it
```sh
docker run \
	-it --rm \
	-p 80:80 \
	dkraemer/stackedit:5.13.3-linux-amd64
```
## Run it
```sh
docker run \
	-d \
	--name stackedit \
	-p 80:80 \
	--restart=unless-stopped \
	dkraemer/stackedit:5.13.3-linux-amd64
```
> Written with [StackEdit](https://stackedit.io/).