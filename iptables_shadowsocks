#!/bin/bash

cd $(cd $(dirname $0); pwd)
rm -fr iptables.shadowsocks.*

cat << EOF > iptables.shadowsocks.`date +%F_%T`
*nat
:shadowsocks -
-A shadowsocks -d 0/8 -j RETURN
-A shadowsocks -d 127/8 -j RETURN
-A shadowsocks -d 10/8 -j RETURN
-A shadowsocks -d 169.254/16 -j RETURN
-A shadowsocks -d 172.16/12 -j RETURN
-A shadowsocks -d 192.168/16 -j RETURN
-A shadowsocks -d 224/4 -j RETURN
-A shadowsocks -d 240/4 -j RETURN
-A shadowsocks -d $1 -j RETURN
-A shadowsocks -m set --match-set chinaip dst -j RETURN
-A shadowsocks ! -p icmp -j REDIRECT --to-ports $2
-A OUTPUT ! -p icmp -j shadowsocks
COMMIT
EOF

if [ ! -e iptables.nat.clean ]; then
    echo -e "*nat\nCOMMIT" > iptables.nat.clean
fi
