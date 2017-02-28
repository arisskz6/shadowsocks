#!/usr/bin/env bash
rm -rf ~/shadowsocks

apt -y install git
cd ~
git clone https://github.com/arisskz6/shadowsocks.git 
chmod u+rx ~/shadowsocks/*.sh
~/shadowsocks/ss_install.sh
