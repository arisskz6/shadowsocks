wget https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz
tar xf chinadns-1.3.2.tar.gz
cd chinadns-1.3.2
./configure && make
cp -af src/chinadns /usr/local/bin/chinadns
mkdir -p /etc/chinadns/
cp -af chnroute.txt /etc/chinadns/
cp -af iplist.txt /etc/chinadns/
