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
setcap 'cap_net_admin,cap_net_bind_service=ep' $PREFIX/opt/hysteria/hysteria
printf "Fetching service files... "
if [ -e "$PREFIX/lib/systemd" ] ; then
	echo "Found Systemd."
	if [ -e "$PREFIX/lib/systemd/system/hysteria.service" ] && [ "$CONF_OVERRIDE" != "1" ] ; then
		echo "Skipped registering."
	else
		printf "Registering... "
		curl -Lso "$PREFIX/lib/systemd/system/hysteria.service" https://github.com/team-cloudchaser/tempest/raw/main/blob/hysteria/hysteria.service
		echo "Registered."
	fi
	if [ -e "$PREFIX/lib/systemd/system/hysteria@.service" ] && [ "$CONF_OVERRIDE" != "1" ] ; then
		echo "Skipped registering."
	else
		printf "Registering... "
		curl -Lso "$PREFIX/lib/systemd/system/hysteria@.service" https://github.com/team-cloudchaser/tempest/raw/main/blob/hysteria/hysteria@.service
		echo "Registered."
	fi
	if [ -e "$PREFIX/lib/systemd/system/hysteria-server.service" ] && [ "$CONF_OVERRIDE" != "1" ] ; then
		echo "Skipped registering."
	else
		printf "Registering... "
		curl -Lso "$PREFIX/lib/systemd/system/hysteria-server.service" https://github.com/team-cloudchaser/tempest/raw/main/blob/hysteria/hysteria-server.service
		echo "Registered."
	fi
	if [ -e "$PREFIX/lib/systemd/system/hysteria-server@.service" ] && [ "$CONF_OVERRIDE" != "1" ] ; then
		echo "Skipped registering."
	else
		printf "Registering... "
		curl -Lso "$PREFIX/lib/systemd/system/hysteria-server@.service" https://github.com/team-cloudchaser/tempest/raw/main/blob/hysteria/hysteria-server@.service
		echo "Registered."
	fi
	systemctl daemon-reload
elif [ -e "$PREFIX/sbin/rc-service" ] ; then
	echo "Found OpenRC."
	if [ -e "$PREFIX/etc/init.d/hysteria" ] && [ "$CONF_OVERRIDE" != "1" ] ; then
		echo "Skipped registering."
	else
		printf "Registering... "
		curl -Lso "$PREFIX/etc/init.d/hysteria" https://github.com/team-cloudchaser/tempest/raw/main/blob/hysteria/hysteria.rc
		chmod +x $PREFIX/etc/init.d/hysteria
		echo "Registered."
	fi
	if [ -e "$PREFIX/etc/init.d/hysteria-server" ] && [ "$CONF_OVERRIDE" != "1" ] ; then
		echo "Skipped registering."
	else
		printf "Registering... "
		curl -Lso "$PREFIX/etc/init.d/hysteria-server" https://github.com/team-cloudchaser/tempest/raw/main/blob/hysteria/hysteria-server.rc
		chmod +x $PREFIX/etc/init.d/hysteria-server
		echo "Registered."
	fi
else
	echo "Not found."
fi
printf "Filling for configuration files... server "
mkdir -p $PREFIX/etc/hysteria/
if [ -e "$PREFIX/etc/hysteria/server.json" ] ; then
	printf "skipped,"
else
	echo "{}" > $PREFIX/etc/hysteria/server.json
	printf "done,"
fi
printf " client "
if [ -e "$PREFIX/etc/hysteria/client.json" ] ; then
	echo "skipped."
else
	echo "{}" > $PREFIX/etc/hysteria/client.json
	echo "done."
fi
echo "Hysteria installation complete."
exit