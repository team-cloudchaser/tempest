#!/bin/bash
if [ -d "./podman-build/${1}/" ] ; then
	cd ./podman-build/${1}
	podman build -t tempest_${1}_latest .
	podman push tempest_${1}_latest docker://docker.io/${DH_USER:-poneyclairdelune}/tempest:${1}
	podman rmi tempest_${1}_latest
else
	echo "Image \"${1}\" not found."
fi
exit