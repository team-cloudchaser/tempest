#!/bin/bash
if [ -d "./podman-build/${1}/" ] ; then
	cd ./podman-build/${1}
	podman build -t gel_${1}_latest .
	podman push gel_${1}_latest docker://docker.io/${DH_USER:-poneyclairdelune}/gel:${1}
	podman rmi gel_${1}_latest
else
	echo "Image \"${1}\" not found."
fi
exit