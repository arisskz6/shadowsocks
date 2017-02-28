#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH 

echo "shadowsocks-python installation is starting..."
ls /usr/local/bin/sslocal > /dev/null 2>&1 && pip uninstall shadowsocks
rm -rf /etc/shadowsocks
rm -f /etc/systemd/system/shadowsocks.service
rm -rf /run/shadowsocks*
apt -y update
apt -y install  python-pip
pip install --upgrade pip > /dev/null 2>&1
pip install shadowsocks && echo "pip install ss completed."
echo
echo "------setting ss config---------"
echo
ls /etc/shadowsocks || mkdir /etc/shadowsocks
cat > /etc/shadowsocks/config.json << "EOF"
{
    "server":"107.182.186.144",
    "server_port":11982,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"0322Qds233",
    "timeout":600,
    "method":"aes-256-cfb",
    "fast_open": false
}
EOF

echo 
echo

echo "[########## ss config set done ##############"
echo
cat > /etc/systemd/system/shadowsocks.service << "EOF"
[Unit]
Description=Shadowsocks
After=network.target

[Service]
Type=forking
PIDFile=/run/shadowsocks/local.pid
PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /run/shadowsocks
ExecStartPre=/bin/chown root:root /run/shadowsocks
ExecStart=/usr/local/bin/sslocal --pid-file /var/run/shadowsocks/local.pid -c /etc/shadowsocks/config.json -d start
Restart=on-abort
User=root
Group=root
UMask=0027

[Install]
WantedBy=multi-user.target
EOF

echo
echo "############# set ss systemd autostart file done #############"
echo
echo "-------------Enabling the ss autostart systemd function----------------------"
echo
systemctl start shadowsocks.service > /dev/null 2>&1
systemctl enable shadowsocks.service > /dev/null 2>&1
systemctl daemon-reload
systemctl restart shadowsocks.service
cp ~/shadowsocks/ss_update.sh ~/ss_update.sh
echo "Congraduations! shadowsocks install comleted!"
echo
echo `systemctl status shadowsocks`
~/shadowsocks/polipo_install.sh
