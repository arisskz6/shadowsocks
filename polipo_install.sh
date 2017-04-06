#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
apt-get --purge remove polipo -y > /dev/null 2>&1
rm -f /etc/polipo/config > /dev/null 2>&1
sed -i '/localhost:8123/d' ~/.bashrc
apt-get -y install polipo curl
rm -f /etc/polipo/config
cp ~/shadowsocks/polipo.config /etc/polipo/config
systemctl restart polipo.service && echo "[Restaring polipo.service....OK]"
echo " alias hp='http_proxy=http://localhost:8123'" >> ~/.bashrc
source ~/.bashrc
http_proxy=http://localhost:8123 curl ip.gs
cat ~/.bashrc | grep 'hp'
echo 
echo "Everything Done!"
echo "run 'source .bashrc' to initialize and enjoy it!"
