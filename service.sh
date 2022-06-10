#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

IPTABLES=/system/bin/iptables
LISTEN_PORT=5053

# DNS redirect to $LISTEN_PORT
# Force a specific DNS
# First two lines deletes current DNS settings
$IPTABLES -t nat -D OUTPUT -p tcp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT
$IPTABLES -t nat -D OUTPUT -p udp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT
$IPTABLES -t nat -D OUTPUT -p tcp ! -d 1.0.0.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT
$IPTABLES -t nat -D OUTPUT -p udp ! -d 1.0.0.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT

# These two lines sets DNS running at 127.0.0.1 on port $LISTEN_PORT
$IPTABLES -t nat -A OUTPUT -p tcp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT
$IPTABLES -t nat -A OUTPUT -p udp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT
$IPTABLES -t nat -A OUTPUT -p tcp ! -d 1.0.0.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT
$IPTABLES -t nat -A OUTPUT -p udp ! -d 1.0.0.1 --dport 53 -j DNAT --to-destination 127.0.0.1:$LISTEN_PORT

while ! [ `pgrep -x cloudflared` ] ; do
    $MODDIR/system/bin/cloudflared proxy-dns --port $LISTEN_PORT --upstream https://1.1.1.1/dns-query --upstream https://1.0.0.1/dns-query && sleep 15;
done


