#!/bin/bash
# Install DNSCrypt Proxy, CoreDNS, Xray, Sing Box and Nightglow.
bash <(curl -L https://github.com/PoneyClairDeLune/tempest/raw/main/install/xray.sh)
bash <(curl -L https://github.com/PoneyClairDeLune/tempest/raw/main/install/singbox.sh)
#bash <(curl -Ls https://github.com/PoneyClairDeLune/tempest/raw/main/install/hysteria.sh)
systemctl enable xray
systemctl enable sing-box
exit
