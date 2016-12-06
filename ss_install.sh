apt-get -y update
apt-get -y install  python-pip  python-m2crypto
pip install shadowsocks

cat > /etc/shadowsocks.json<<-EOF
{
    "server":"217.65.87.253",
    "server_port":11024,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"PaiayNVG",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false
}
EOF

sslocal -c /etc/shadowsocks.json -d start
apt-get -y install supervisor

cat > /etc/supervisor/conf.d/shadowsocks.conf<<-EOF
[program:shadowsocks]
command=sslocal -c /etc/shadowsocks.json
autorestart=true
user=nobody
EOF

service supervisor start
supervisorctl reload                                                           
