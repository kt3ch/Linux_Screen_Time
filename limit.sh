#!/bin/bash

modprobe ifb numifbs=1      #create virtual interface
ip link set dev ifb0 up     #insert interface
tc qdisc add dev ens33 handle ffff: ingress
tc filter add dev ens33 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
# pipe the ingress of ens33 to the congress of the new virtual interface

tc qdisc add dev ifb0 root handle 1: htb default 10
tc class add dev ifb0 parent 1: classid 1:1 htb rate 1mbit
tc class add dev ifb0 parent 1:1 classid 1:10 htb rate 1mbit
