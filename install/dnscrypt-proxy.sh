#!/bin/bash
# Adapted from a version written in 2021, no offline install support yet
# Prerequisites checks
if [ ! -f "$(which tar)" ]; then
	echo "Required command not found: tar"
	exit 1
fi
if [ ! -f "$(which gzip)" ]; then
	echo "Required command not found: gzip"
	exit 1
fi
if [ ! -f "$(which curl)" ]; then
	echo "Required command not found: curl"
	exit 1
fi
if [ ! -e "$PREFIX/etc/systemd" ]; then
	echo "This script does not work for systems without systemd yet."
	exit 1
fi
# Select the appropriate architecture
debArch=$(uname -m)
transArch=$debArch
case $debArch in
	"i386" | "i686")
		transArch="i386"
		;;
	"x86_64" | "amd64")
		transArch="x86_64"
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch="arm64"
		;;
esac
# Copy and paste jobs below with slight modifications
getos=linux
getarch="${transArch}"
getver="${INSTALL_VER:-2.1.5}"
downloadPath="https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/${getver}/dnscrypt-proxy-${getos}_${getarch}-${getver}.tar.gz"
srcRepoUrl="https://github.com/PoneyClairDeLune/tempest/raw/main/blob/dnscrypt-proxy"
mkdir -p $PREFIX/opt && cd $PREFIX/opt
echo "Downloading DNSCrypt Proxy from [${downloadPath}] ..."
curl -Lo dnscrypt.tgz $downloadPath
if [ -f "./dnscrypt.tgz" ]; then
	tar -zxvf dnscrypt.tgz
else
	echo "Download failed."
	exit 1
fi
rm "dnscrypt.tgz"
cd "./linux-${getarch}"
if [ ! -e "dnscrypt-proxy.toml" ] ; then
	curl -Lo dnscrypt-proxy.toml "$srcRepoUrl/dnscrypt-proxy.toml"
	#curl -Lo uninstall.sh "$srcRepoUrl/uninstall.sh"
	chmod +x uninstall.sh
	read -p 'Do you have IPv6 connection? ("y" for enable IPv6): ' getipv6
	if [ "$getipv6" == "y" ] ; then
		sed -i 's/ipv6_servers = false/ipv6_servers = true/g' dnscrypt-proxy.toml
	fi
	read -p 'Do you want to use Google DoH? ("y" for enable): ' getgoogle
	# dohReplaced="_SED_REPLACE_SERVERS_"
	# dohNoGoogle="'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'cloudflare', 'nextdns'"
	# dohHasGoogle="'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'google', 'cloudflare', 'nextdns'"
	if [ "$getgoogle" == "y" ] ; then
		sed -i "s/_SED_REPLACE_SERVERS_/'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'google', 'cloudflare', 'nextdns'/g" dnscrypt-proxy.toml
	else
		sed -i "s/_SED_REPLACE_SERVERS_/'doh.appliedprivacy.net', 'njalla-doh', 'quad9', 'cloudflare', 'nextdns'/g" dnscrypt-proxy.toml
	fi
fi
echo "Disabling conflicting system resolvers..."
systemctl stop systemd-resolved
systemctl disable systemd-resolved
systemctl stop resolvconf
systemctl disable resolvconf
if [ ! -e "/etc/resolv.conf.bak" ] ; then
	echo 'Rewriting resolving configs...'
	mv /etc/resolv.conf /etc/resolv.conf.bak
	echo "nameserver 127.0.0.1" > /etc/resolv.conf
	echo "options edns0" >> /etc/resolv.conf
fi
echo "Installing as a service..."
./dnscrypt-proxy -service install
./dnscrypt-proxy -service start
sleep 5s
echo "Now let's test whether it is working!"
sleep 2s
./dnscrypt-proxy -resolve www.google.com
./dnscrypt-proxy -resolve www.debian.org
./dnscrypt-proxy -resolve alpinelinux.org
echo "All done. If no errors were spotted, enjoy!"
exit