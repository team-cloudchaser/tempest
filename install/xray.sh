#!/bin/bash
appName="Xray"
debArch=$(uname -m)
transArch=$debArch
case $debArch in
	"i386" | "i686")
		transArch=32
		;;
	"x86_64" | "amd64")
		transArch=64
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch="arm64-v8a"
		;;
esac
echo "Installing $appName for $debArch..."
echo "Installing dependencies..."
apt install -y apt-transport-https unzip
if [ -e "$PREFIX/opt/xray" ] ; then
	echo "Directory already existed."
else
	mkdir -p $PREFIX/opt/xray
fi
if [ -e "./xray.zip" ] ; then
	echo "Copying xray to /opt ..."
	cp ./xray.zip $PREFIX/opt/xray/
else
	echo "Downloading xray..."
	curl -sLo $PREFIX/opt/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-$transArch.zip
fi
echo "Extracting archive..."
cd $PREFIX/opt/xray/
unzip -o xray.zip && rm xray.zip
echo "Linking executables..."
if [ -e "$PREFIX/bin/xray" ] ; then
	echo "Found pre-existing copy."
else
	ln -s $PREFIX/opt/xray/xray $PREFIX/bin/xray
fi
printf "Testing Systemd... "
if [ -e "$PREFIX/lib/systemd" ] ; then
	echo "found."
	if [ -e "$PREFIX/lib/systemd/system/xray.service" ] ; then
		echo "Skipped registering."
	else
		echo "Registering Xray as service..."
		curl -Lo "$PREFIX/lib/systemd/system/xray.service" https://github.com/PoneyClairDeLune/tempest/raw/main/blob/xray/xray.service
		echo "Reloading daemon..."
		systemctl daemon-reload
	fi
	if [ -e "$PREFIX/lib/systemd/system/xray@.service" ] ; then
		echo "Skipped registering."
	else
		echo "Registering Xray as service..."
		curl -Lo "$PREFIX/lib/systemd/system/xray@.service" https://github.com/PoneyClairDeLune/tempest/raw/main/blob/xray/xray@.service
		echo "Reloading daemon..."
		systemctl daemon-reload
	fi
else
	echo "not found."
fi
echo "Filling for configuration files..."
mkdir -p $PREFIX/etc/xray/
echo "{}" > $PREFIX/etc/xray/config.json
if [ -e "$PREFIX/usr" ] ; then
	if [ -e "$PREFIX/usr/local" ] ; then
		echo "Adding fallback..."
		mkdir -p $PREFIX/usr/local/etc/
		ln -s $PREFIX/etc/xray $PREFIX/usr/local/etc/
	fi
fi
echo "Xray is now installed on your system. Modify /etc/xray/config.json for more info."
