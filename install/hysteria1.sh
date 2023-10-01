#!/bin/bash
platform=linux
debArch=$(uname -m)
transArch=$debArch
case $debArch in
	"i386" | "i686")
		transArch=386
		;;
	"x86_64" | "amd64")
		transArch=amd64
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch=arm64
		;;
esac
if [ "$1" == "tun" ] ; then
    platform=tun-${platform}
fi
echo "Installing Hysteria..."
oldPwd=$(pwd)
mkdir -p $PREFIX/opt/hysteria
cd $PREFIX/opt/hysteria
if [ -e "$oldPwd/hysteria" ] ; then
    cp "$oldPwd/hysteria" ./hysteria
else
    curl -Lo hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-${platform}-${transArch}
fi
chmod +x hysteria
ln -s $PREFIX/opt/hysteria/hysteria $PREFIX/bin/hysteria
echo "Hysteria installation complete."
exit
