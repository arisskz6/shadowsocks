apt -y install polipo
rm -f /etc/polipo/config
cp ~/shadowsocks/polipo.config /etc/polipo/config
/etc/init.d/polipo restart
export http_proxy="http://127.0.0.1:8123/"
curl ifconfig.me
