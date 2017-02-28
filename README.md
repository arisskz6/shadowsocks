## oneclick shadowsocks install script
------------------------------------------------------------------------------------------------------
## Introduction
One click Install **Shadowsocks-Python Client** on **Debian Local Machine**,as well as set up **Polipo http_proxy**

builtin my own ss account

*tested on `debian jessie`and `ubuntu 16.04`*

Poor English,forgive me,please.

*I'm a beginner on GUN/Linux,and my PC mainly run Debian,I use shadowsocks to reach the real Internet,so this script is simple and ugly,but it is useful,I'll continue to improve it,hope it help  ^_*
## Usage
+ **If this is the first time for you to run this script**

```
su root
apt -y install git
chmod 744 ~/shadowsocks/*.sh
cd ~/shadowsocks
./ss_install.sh
```
+ **If you wanna update the shadowsocks**

`bash ~/shadowsocks/ss_update.sh`

or `./ss_update.sh`

+ **Control**

```
systemctl [start/status/restart] shadowsocks.service
```

thanks to `@clowwindy` and all of others fight for GFW

OS:Debian 8+/Ubuntu 16.04+
------------------------------------------------------------------------------------------------------
`2016-11-13,by arisskz6`

updated `2017-02-28`,added polipo for terminal http proxy
