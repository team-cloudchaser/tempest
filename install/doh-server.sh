#!/bin/bash
platform=linux
debArch=$(uname -m)
transArch=$debArch
installVer="0.9.11"
case $debArch in
	"x86_64" | "amd64")
		transArch=x86_64
		;;
	"arm64" | "armv8l" | "aarch64")
		transArch=aarch64
		;;
esac
if [ ! -f "$(which tar)" ]; then
	echo "tar support is not present on your system. Quitting."
	exit 1
fi
if [ ! -f "$(which bzip2)" ]; then
	echo "bzip2 support is not present on your system."
	if [ -f "$(which apt)" ]; then
		apt install -y xz-utils
	elif [ -f "$(which apk)" ]; then
		apk add xz
	elif [ -f "$(which zypper)" ]; then
		zypper --gpg-auto-import-keys in -y xz
	elif [ -f "$(which dnf)" ]; then
		dnf install -y xz
	else
		echo "Cannot find supported package manager, quitting."
		exit 1
	fi
fi
echo "Installing the DNSCrypt DoH Server... May not yet work on Alpine."
oldPwd="$(pwd)"
mkdir -p "$PREFIX/opt/doh-server"
cd "$PREFIX/opt/doh-server"
if [ -f "${oldPwd}/doh-server.tar.xz" ]; then
	cp "${oldPwd}/doh-server.tar.xz" "./"
else
	curl -Lo "doh-server.tar.xz" "https://github.com/DNSCrypt/doh-server/releases/download/${installVer}/doh-proxy_${installVer}_${platform}-${transArch}.tar.bz2"
	cp "./doh-server.tar.xz" "${oldPwd}/"
fi
xz -d -v "./doh-server.tar.xz"
cd ".."
tar xvf "./doh-server/doh-server.tar"
mv ./doh-proxy/* "./doh-server"
rmdir "./doh-proxy"
cd "doh-server"
echo "Linking executable to path..."
if [ ! -f "$(which doh-server)" ]; then
	ln -s "$PREFIX/opt/doh-server/doh-proxy" "$PREFIX/bin/doh-server"
fi
mkdir -p "$PREFIX/etc/doh-server"
if [ ! -f "$PREFIX/etc/doh-server/default.sh" ]; then
	echo "Initializing config files..."
	targetFile = "$PREFIX/etc/doh-server/default.sh"
	echo "#!/bin/bash" > $targetFile
	echo "doh-server -H example.com -p \"/dns-query\" -l 127.0.0.1:3053 -u 127.0.0.1:53 -t 4 -c 256 -C 16 -T 16 -X 86400"
	echo "exit" >> $targetFile
fi
printf "Fetching service files... "
if [ -e "$PREFIX/sbin/rc-service" ]; then
	echo "Found systemd."
	curl -Lo "$PREFIX/lib/systemd/system/doh-server.service" https://github.com/team-cloudchaser/tempest/raw/main/blob/doh-server/doh-server.service
	curl -Lo "$PREFIX/lib/systemd/system/doh-server@.service" https://github.com/team-cloudchaser/tempest/raw/main/blob/doh-server/doh-server@.service
elif [ -e "$PREFIX/lib/systemd" ]; then
	echo "Found OpenRC."
	curl -Lo "$PREFIX/etc/init.d/doh-server" https://github.com/team-cloudchaser/tempest/raw/main/blob/doh-server/doh-server.rc
	chmod +x "$PREFIX/etc/init.d/doh-server"
else
	echo "Not found."
fi
echo "Installation finished."
exit