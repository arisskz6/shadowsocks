#!/bin/bash
# Program:
# This is a simple script to install  and
# configure shadowsocksr-python client 
# on Linux...
# History:
# 2017/05/28  First Release by Arisskz6
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Success="${Green_font_prefix}[大功告成！]${Font_color_suffix}"

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1

# Stop the shadowsocksr client
python ~/shadowsocksr/shadowsocks/local.py -c ~/shadowsocksr/user-config.json -d stop
# Set shadowsocksr config ip
while [ "$yno" == "" ]
do
    read -p "Use the account set in advance.Y/n?" yn

    if [ "$yn" == Y ] || [ "$yn" == y ]; then
        yno=1
        echo "Using the default doubiss account HK 2"
    	shadowsocksrip="27.0.232.201"
    	shadowsocksrpwd="PaiayNVG"
    	shadowsocksrport=11024
    	shadowsocksrmethod="aes-256-cfb"
    	shadowsocksrproto="auth_aes128_md5"
    	shadowsocksrobfs="tls1.2_ticket_auth"
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
    	read -p "Default method: aes-128-ctr:" shadowsocksrmethod
    	[ -z "${shadowsocksrmethod}" ] && shadowsocksrmethod="aes-128-ctr"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "method= ${shadowsocksrmethod}"
    	echo "-----------------------------------------------------"
    	echo

    	# Set shadowsocksr config protocol
    	echo "Please enter the server protocol"
    	read -p "Default protocol: auth_aes128_md5:" shadowsocksrproto
    	[ -z "${shadowsocksrproto}" ] && 
	shadowsocksrproto="auth_aes128_md5"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "protocol = ${shadowsocksrproto}"
   	echo "-----------------------------------------------------"
    	echo

    	# Set shadowsocksr config obfs
    	echo "Please enter the server obfs"
    	read -p "Default obfs: tls1.2_ticket_auth_compatible:" shadowsocksrobfs
    	[ -z "${shadowsocksrobfs}" ] && 
	shadowsocksrobfs="tls1.2_ticket_auth_compatible"
    	echo 
    	echo "-----------------------------------------------------"
    	echo "obfs = ${shadowsocksrobfs}"
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
sed -i "s/\"timeout\":.*$/\"timeout\": 600,/" "$config_path"


python ~/shadowsocksr/shadowsocks/local.py -c ~/shadowsocksr/user-config.json -d start
echo 
echo "-----"
echo "${Success}"
echo "-----"
echo
proxychains4 curl ip.gs
exit 0
