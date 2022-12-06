#!/bin/bash

# Setup Forwarding and NAT on Management VM
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s 192.168.88.101 -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 192.168.88.102 -o eth0 -j MASQUERADE

# Setup VmB Gateway
ssh vmB sudo ip route del default
ssh vmB sudo ip route add default via 192.168.88.100

# Setup VmC Gateway
ssh vmC sudo ip route del default
ssh vmC sudo ip route add default via 192.168.88.100
