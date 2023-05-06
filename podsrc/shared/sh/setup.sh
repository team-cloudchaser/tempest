#!/bin/bash
bash <(curl -Ls https://github.com/PoneyClairDeLune/tempest/raw/main/install/xray.sh)
bash <(curl -Ls https://github.com/PoneyClairDeLune/tempest/raw/main/install/singbox.sh)
bash <(curl -Ls https://github.com/PoneyClairDeLune/tempest/raw/main/install/hysteria.sh)
systemctl enable xray
exit
