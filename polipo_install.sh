apt purge polipo -y
rm -f /etc/polipo/config > /dev/null 2>&1
apt -y install polipo
rm -f /etc/polipo/config
cp ~/shadowsocks/polipo.config /etc/polipo/config
/etc/init.d/polipo restart
alias hp='http_proxy=http://localhost:8123'
echo "alias hp='http_proxy=http://localhost:8123'" >> ~/.bashrc
source ~/.bashrc
http_proxy=http://localhost:8123 curl ip.gs
cat ~/.bashrc | grep 'hp'