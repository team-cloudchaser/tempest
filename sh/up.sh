#!/bin/bash
shx build
if [ -d "./podman-build/${1}/" ] ; then
	cd ./podman-build/${1}
	podman stop ${1}_gel_1
	podman container rm ${1}_gel_1
	podman rmi ${1}_gel
	podman-compose up -d
else
	echo "Image \"${1}\" not found."
fi
exit