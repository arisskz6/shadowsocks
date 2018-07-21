#!/bin/bash
# Program:
# This is a simple script to install  and
# configure shadowsocksr-python client 
# on Linux...
# History:
# 2017/05/28  First Release by Arisskz6
# 2017/06/04 Arisskz6 add root auth and 
# complete the ssr download step...
# 2017/06/09 Add systemd auto start function
# 2018/01/25 Updated the sever config
# 2018/07/21 Updated the Default Server

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Success="${Green_font_prefix}[SSR-Python版已安装]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Auto_start="${Green_font_prefix}[开机自启配置完成，Enjoy IT！]${Font_color_suffix}"
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo -e "${Error} \033[41;37m You must be root to run this script! \033[0m"
	echo
    exit 1
fi


# Stop the shadowsocksr client
systemctl stop shadowsocksr.service
# remove the old shadowsocksr directory
ynpo=""
while [ -z "$ynpo" ]
do
    read -p "Remove the old shadowsocksr directory? Y/n" rmod_dir
    if [ "$rmod_dir" == 'Y' ] || [ "$rmod_dir" == 'y' ] || [ -z "$rmod_dir" ]; then
        rm -rf ~/shadowsocksr
        ynpo=1
    elif [ "$rmod_dir" == 'N' -o "$rmod_dir" == 'n' ]; then
        ynpo=2
    else
        ynpo=""
    fi
done

rm -rf /var/run/shadowsocksr
systemctl disable /etc/systemd/system/shadowsocksr.service
rm -f /etc/systemd/system/shadowsocksr.service

# clone shadowsocksr from github
cd ~ && git clone -b manyuser https://github.com/shadowsocksrr/shadowsocksr.git
if [ ! -d ~/shadowsocksr ]; then
    echo -e "${Error} Fail to clone shadowsocksr from github!"
    exit 2
fi

# Initialization
  cd ~/shadowsocksr/ && bash initcfg.sh
# Set shadowsocksr config ip
while [ "$yno" == "" ]
do
    read -p "Use the account set in advance.Y/n?" yn

    if [ "$yn" == Y ] || [ "$yn" == y ]; then
        yno=1
        echo "Using the Default Server"
    	shadowsocksrip=$(echo MTA0LjE5OS4xNjUuMTM2 | base64 -d)
    	shadowsocksrpwd="0322Qds233"
    	shadowsocksrport=11982
    	shadowsocksrmethod="chacha20-ietf"
    	shadowsocksrproto="auth_sha1_v4"
    	shadowsocksrobfs="tls1.2_ticket_fastauth"
    elif [ "$yn" == N ] || [ "$yn" == n ]; then
        yno=2
        read -p "Please enter the server ip:" shadowsocksrip
    	echo 
    	echo "-----------------------------------------------------"
    	echo "server_ip = ${shadowsocksrip}"
    	echo "-----------------------------------------------------"
    	echo
    	# Set shadowsocksr config password
    	echo "please enter the password of the server"
    	read -p "please enter the password of the server:" shadowsocksrpwd
    	echo 
    	echo "-----------------------------------------------------"
    	echo "password = ${shadowsocksrpwd}"
    	echo "-----------------------------------------------------"
    	echo
    	# Set shadowsocksr config port
    	read -p "Please enter the server port:" shadowsocksrport
    	echo 
    	echo "-----------------------------------------------------"
    	echo "server_port = ${shadowsocksrport}"
    	echo "-----------------------------------------------------"
    	echo
    	# Set shadowsocksr config encrypt method
    	echo "Please enter the server encrypt method"
    	read -p "Default method: chacha20-ietf:" shadowsocksrmethod
    	[ -z "${shadowsocksrmethod}" ] && shadowsocksrmethod="chacha20-ietf"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "method= ${shadowsocksrmethod}"
    	echo "-----------------------------------------------------"
    	echo

    	# Set shadowsocksr config protocol
    	echo "Please enter the server protocol"
    	read -p "Default protocol: auth_sha1_v4:" shadowsocksrproto
    	[ -z "${shadowsocksrproto}" ] && 
	shadowsocksrproto="auth_sha1_v4"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "protocol = ${shadowsocksrproto}"
   	echo "-----------------------------------------------------"
    	echo

    	# Set shadowsocksr config obfs
    	echo "Please enter the server obfs"
    	read -p "Default obfs: tls1.2_ticket_auth:" shadowsocksrobfs
    	[ -z "${shadowsocksrobfs}" ] && 
	shadowsocksrobfs="tls1.2_ticket_auth"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "obfs = ${shadowsocksrobfs}"
    	echo "-----------------------------------------------------"
    	echo
	
    	# Set shadowsocksr config obfs_param
    	echo "Please enter the server obfs_param"
    	read -p "Default obfs_param: origin.cdn77.com:" shadowsocksrobfs_param
    	[ -z "${shadowsocksrobfs_param}" ] && 
	shadowsocksrobfs_param="origin.cdn77.com"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "obfs_param = ${shadowsocksrobfs_param}"
    	echo "-----------------------------------------------------"
    	echo	
    else
        yno=""
fi

done

config_path=~/shadowsocksr/user-config.json

sed -i "s/\"server\":.*$/\"server\": \"${shadowsocksrip}\",/" "$config_path"
sed -i '/server_ipv6/d' "$config_path"
sed -i  "s/\"server_port\":.*$/\"server_port\": ${shadowsocksrport},/" "$config_path"
sed -i "s/\"password\":.*$/\"password\": \"${shadowsocksrpwd}\",/" "$config_path"
sed -i "s/\"method\":.*$/\"method\": \"${shadowsocksrmethod}\",/" "$config_path"
sed -i "s/\"protocol\":.*$/\"protocol\": \"${shadowsocksrproto}\",/" "$config_path"
sed -i "s/\"obfs\":.*$/\"obfs\": \"${shadowsocksrobfs}\",/" "$config_path"
sed -i "s/\"obfs_param\":.*$/\"obfs_param\": \"${shadowsocksrobfs_param}\",/" "$config_path"
sed -i "s/\"timeout\":.*$/\"timeout\": 300,/" "$config_path"


python ~/shadowsocksr/shadowsocks/local.py -c ~/shadowsocksr/user-config.json -d start
echo
echo "-----------"
echo -e "${Success}"
echo "-----------"
echo
proxychains curl ip.sb

# Stop the origional ssr client
python /root/shadowsocksr/shadowsocks/local.py -c /root/shadowsocksr/user-config.json -d stop
echo "Shadowsocksr stopped"
echo
echo "--Setting ShadowsocksR systemd autostart configure file..."
# Set ShadowsocksR systemd autostart configure file
cat > /etc/systemd/system/shadowsocksr.service << "EOF"
[Unit]
Description=ShadowsocksR
After=network.target
[Service]
Type=forking
PIDFile=/run/shadowsocksr/local.pid
PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /run/shadowsocksr
ExecStartPre=/bin/chown root:root /run/shadowsocksr
ExecStart=/usr/bin/python /root/shadowsocksr/shadowsocks/local.py --pid-file /var/run/shadowsocksr/local.pid -c /root/shadowsocksr/user-config.json -d start
Restart=on-abort
User=root
Group=root
UMask=0027
[Install]
WantedBy=multi-user.target
EOF
echo
echo "############# set ssr systemd autostart file done #############"
echo
echo
echo "-------------Enabling the ss autostart systemd function----------------------"
echo
systemctl start shadowsocksr.service > /dev/null 2>&1
systemctl enable shadowsocksr.service > /dev/null 2>&1
systemctl daemon-reload
systemctl restart shadowsocksr.service
systemctl status shadowsocksr.service | head -10
echo
echo "------------------"
echo -e "${Auto_start}"
echo "------------------"
echo
proxychains curl ip.sb
exit 0
