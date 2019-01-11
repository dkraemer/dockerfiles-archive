# Stackedit
## Test it
```sh
docker run \
	-it \
	--rm \
	--name stackedit \
	-p 80:80 \
	dkraemer/stackedit
```
## Run it
```sh
docker run \
	-d \
	--name stackedit \
	-p 80:80 \
	--restart=unless-stopped \
	dkraemer/stackedit
```
> Written with [StackEdit](https://stackedit.io/).