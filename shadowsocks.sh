#!/bin/bash

ss_server=67.216.222.205
ss_port=11982
ss_method=chacha20
ss_pass=0322Qds233
listen_port=1080
dns_listen_port=1053
dns_upstream=114.114.114.114,127.0.0.1:${dns_listen_port}

case $1 in
start)
    nohup ss-redir -s ${ss_server} -p ${ss_port} -m ${ss_method} -k ${ss_pass} -u -b '0.0.0.0' -l ${listen_port} -v &>> /var/log/ss-redir.log &
    nohup ss-tunnel -s ${ss_server} -p ${ss_port} -m ${ss_method} -k ${ss_pass} -u -b '0.0.0.0' -l ${dns_listen_port} -L '8.8.8.8:53' -v &>> /var/log/ss-tunnel.log &
    nohup chinadns -c /etc/chinadns/chnroute.txt -l /etc/chinadns/iplist.txt -b 0.0.0.0 -p 53 -s ${dns_upstream} -d -v &>> /var/log/chinadns.log &
    ipset -R < $(cd $(dirname $0); pwd)/ipset.chinaip.*
    iptables-restore < $(cd $(dirname $0); pwd)/iptables.shadowsocks.*
    ;;
stop)
    iptables-restore < $(cd $(dirname $0); pwd)/iptables.nat.clean
    ipset -X chinaip &> /dev/null
    kill -9 `ps -ef | egrep '\schinadns\s' | egrep -v 'grep' | awk '{print $2}'` &> /dev/null
    kill -9 `ps -ef | egrep '\sss-redir\s' | egrep -v 'grep' | awk '{print $2}'` &> /dev/null
    kill -9 `ps -ef | egrep '\sss-tunnel\s' | egrep -v 'grep' | awk '{print $2}'` &> /dev/null
    ;;
*)
    echo "usage: $(cd $(dirname $0); pwd)/shadowsocks.sh start|stop"
    exit 1
    ;;
esac
