#!/bin/bash
case "$1" in
start)
modprobe ifb numifbs=1
ip link set dev ifb0 up
tc qdisc add dev eth0 handle ffff: ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0


cgcreate -g net_cls:0
echo 0x100001 > /sys/fs/cgroup/net_cls/0/net_cls.classid


tc qdisc add dev ifb0 root handle 1: htb default 10
tc class add dev ifb0 parent 1: classid 1:1 htb rate 512kbit
tc class add dev ifb0 parent 1:1 classid 1:10 htb rate 512kbit

tc qdisc add dev eth0 root handle 1: htb default 10
tc class add dev eth0 parent 1: classid 1:1 htb rate 512kbit
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 512kbit 
;;
end)
tc qdisc del dev eth0 root
tc qdisc del dev ifb0 root
tc qdisc del dev eth0 ingress
;;
esac
