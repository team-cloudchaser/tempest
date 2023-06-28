#!/bin/bash
appName="Sing Box"
debArch=$(uname -m)
transArch=$debArch
targetVer=${INSTALL_VER:-1.3.0}
case $debArch in
	"x86_64" | "amd64")
		transArch="amd64"
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch="arm64"
		;;
esac
echo "Installing $appName for $debArch..."
echo "Preparing folders..."
if [ -e "$PREFIX/opt/sing-box" ] ; then
	echo "Directory already existed."
else
	mkdir -p $PREFIX/opt/sing-box
fi
filename="sing-box-${targetVer}-linux-${transArch}"
if [ -e "./sing-box.tgz" ] ; then
	echo "Copying sing-box to /opt ..."
	cp ./sing-box.tgz $PREFIX/opt/sing-box/
else
	echo "Downloading sing-box..."
	curl -Lso $PREFIX/opt/sing-box/sing-box.tgz https://github.com/SagerNet/sing-box/releases/download/v${targetVer}/${filename}.tar.gz
fi
cd $PREFIX/opt/sing-box/
echo "Extracting archives..."
tar zxvf sing-box.tgz && rm sing-box.tgz
mv ./${filename}/* ./
rmdir ./${filename}
echo "Linking executables..."
if [ -e "$PREFIX/bin/sing-box" ] ; then
	echo "Found pre-existing copy."
else
	ln -s $PREFIX/opt/sing-box/sing-box $PREFIX/bin/sing-box
fi
printf "Testing Systemd... "
if [ -e "$PREFIX/lib/systemd" ] ; then
	echo "found."
	if [ -e "$PREFIX/lib/systemd/system/sing-box.service" ] ; then
		echo "Skipped registering."
	else
		echo "Registering sing-box as service..."
		curl -Lo "$PREFIX/lib/systemd/system/sing-box.service" https://github.com/PoneyClairDeLune/tempest/raw/main/blob/sing-box/sing-box.service
		echo "Reloading daemon..."
		systemctl daemon-reload
	fi
	if [ -e "$PREFIX/lib/systemd/system/sing-box@.service" ] ; then
		echo "Skipped registering."
	else
		echo "Registering sing-box as service..."
		curl -Lo "$PREFIX/lib/systemd/system/sing-box@.service" https://github.com/PoneyClairDeLune/tempest/raw/main/blob/sing-box/sing-box@.service
		echo "Reloading daemon..."
		systemctl daemon-reload
	fi
elif [ -e "$PREFIX/sbin/rc-service" ] ; then
	echo "using OpenRC instead."
	if [ -e "$PREFIX/etc/init.d/sing-box" ] ; then
		echo "Skipped registering."
	else
		echo "Registering Sing Box as service..."
		curl -Lo "$PREFIX/etc/init.d/sing-box" https://github.com/PoneyClairDeLune/tempest/raw/main/blob/sing-box/sing-box.rc
		chmod +x $PREFIX/etc/init.d/sing-box
	fi
else
	echo "not found."
fi
echo "Filling for configuration files..."
mkdir -p $PREFIX/etc/sing-box/
echo "{}" > $PREFIX/etc/sing-box/config.json
echo "Sing Box is now installed on your system. Modify /etc/sing-box/config.json for more info."
exit