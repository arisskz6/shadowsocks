#!/usr/bin/env bash
rm -rf ~/shadowsocks
sudo apt-get install git -y
cd ~
git clone https://github.com/arisskz6/shadowsocks.git 
chmod u+rx ~/shadowsocks/*.sh
~/shadowsocks/ss_install.sh
