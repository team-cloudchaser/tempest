#!/bin/bash
appName="V2Ray"
#debVer=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
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
if [ -e "$PREFIX/opt/v2ray" ] ; then
	echo "Directory already existed."
else
	mkdir -p $PREFIX/opt/v2ray
fi
if [ -e "./v2ray.zip" ] ; then
	echo "Copying V2Ray to /opt ..."
	cp ./v2ray.zip $PREFIX/opt/v2ray/
else
	echo "Downloading V2Ray..."
	curl -sLo $PREFIX/opt/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-$transArch.zip
fi
echo "Extracting archive..."
cd $PREFIX/opt/v2ray/
unzip -o v2ray.zip && rm v2ray.zip
echo "Linking executables..."
if [ -e "$PREFIX/bin/v2ray" ] ; then
	echo "Found pre-existing copy."
else
	ln -s $PREFIX/opt/v2ray/v2ray $PREFIX/bin/v2ray
fi
if [ -e "$PREFIX/bin/v2ctl" ] ; then
	echo "Found pre-existing copy."
else
	ln -s $PREFIX/opt/v2ray/v2ctl $PREFIX/bin/v2ctl
fi
printf "Testing Systemd... "
if [ -e "$PREFIX/lib/systemd" ] ; then
	echo "found."
	if [ -e "$PREFIX/lib/systemd/system/v2ray.service" ] ; then
		echo "Skipped registering."
	else
		echo "Registering V2Ray as service..."
		cp ./systemd/system/v2ray.service "$PREFIX/lib/systemd/system/"
		echo "Reloading daemon..."
		systemctl daemon-reload
	fi
	if [ -e "$PREFIX/lib/systemd/system/v2ray@.service" ] ; then
		echo "Skipped registering."
	else
		echo "Registering V2Ray as service..."
		cp ./systemd/system/v2ray@.service "$PREFIX/lib/systemd/system/"
		echo "Reloading daemon..."
		systemctl daemon-reload
	fi
else
	echo "not found."
fi
echo "Filling for configuration files..."
mkdir -p $PREFIX/etc/v2ray/
cp -n ./*.json $PREFIX/etc/v2ray/
if [ -e "$PREFIX/usr" ] ; then
	if [ -e "$PREFIX/usr/local" ] ; then
		echo "Adding fallback..."
		mkdir -p $PREFIX/usr/local/etc/
		ln -s $PREFIX/etc/v2ray $PREFIX/usr/local/etc/
	fi
fi
echo "V2Ray is now installed on your system. Modify /etc/v2ray/config.json for more info."
