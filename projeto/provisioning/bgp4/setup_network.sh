#!/bin/bash

# public networks
sudo docker network create public_net1 --subnet=172.31.255.0/27 --gateway=172.31.255.1
sudo docker network create public_net2 --subnet=172.31.255.32/27 --gateway=172.31.255.33
sudo docker network create public_net3 --subnet=172.31.255.64/27 --gateway=172.31.255.65
sudo docker network create public_net4 --subnet=172.31.255.96/27 --gateway=172.31.255.97

# org1 nets
sudo docker network create org1_pub1_net --subnet=172.16.123.0/28 --gateway=172.16.123.1
sudo docker network create org1_int1_net --subnet=10.0.1.0/29 --gateway=10.0.1.1

# org2 nets
sudo docker network create org2_int1_net --subnet=10.0.2.0/29 --gateway=10.0.2.1

# org3 nets
sudo docker network create org3_int1_net --subnet=10.0.3.0/29 --gateway=10.0.3.1

# org4 nets
sudo docker network create org4_int1_net --subnet=10.0.4.0/29 --gateway=10.0.4.1
sudo docker network create org4_pub1_net --subnet=172.16.123.16/28 --gateway=172.16.123.17

# org1 routers
echo ">>>>R1.1"
sudo docker run --rm -d --net org1_int1_net --ip 10.0.1.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org1.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org1_router1 netubuntu 
sudo docker network connect org1_pub1_net org1_router1 --ip 172.16.123.3
sudo docker network connect public_net1 org1_router1 --ip 172.31.255.2
sudo docker network connect public_net2 org1_router1 --ip 172.31.255.34
sudo docker exec org1_router1 /bin/bash -c 'ip r del default via 10.0.1.1'


# org2 routers
echo ">>>>R2.1"
sudo docker run --rm -d --net org2_int1_net --ip 10.0.2.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org2.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org2_router1 netubuntu 
sudo docker network connect public_net1 org2_router1 --ip 172.31.255.3
sudo docker network connect public_net3 org2_router1 --ip 172.31.255.67
sudo docker network connect public_net4 org2_router1 --ip 172.31.255.98
sudo docker exec org2_router1 /bin/bash -c 'ip r del default via 10.0.2.1'


# org3 routers
echo ">>>>R3.1"
sudo docker run --rm -d --net org3_int1_net --ip 10.0.3.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org3.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org3_router1 netubuntu 
sudo docker network connect public_net2 org3_router1 --ip 172.31.255.35
sudo docker network connect public_net3 org3_router1 --ip 172.31.255.66
sudo docker exec org3_router1 /bin/bash -c 'ip r del default via 10.0.3.1'


# org4 routers
echo ">>>>R4.1"
sudo docker run --rm -d --net org4_int1_net --ip 10.0.4.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org4.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org4_router1 netubuntu 
sudo docker network connect public_net4 org4_router1 --ip 172.31.255.99
sudo docker network connect org4_pub1_net org4_router1 --ip 172.16.123.19
sudo docker exec org4_router1 /bin/bash -c 'ip r del default via 10.0.4.1'


echo ">>>>S1.1"
sudo docker run --rm -d --net org1_pub1_net --ip 172.16.123.2 --cap-add=NET_ADMIN --name org1_server1 netubuntu 
sudo docker exec org1_server1 /bin/bash -c 'ip r del default via 172.16.123.1'
sudo docker exec org1_server1 /bin/bash -c 'ip r add default via 172.16.123.3'

echo ">>>>S4.1"
sudo docker run --rm -d --net org4_pub1_net --ip 172.16.123.18 --cap-add=NET_ADMIN --name org4_server1 netubuntu 
sudo docker exec org4_server1 /bin/bash -c 'ip r del default via 172.16.123.17'
sudo docker exec org4_server1 /bin/bash -c 'ip r add default via 172.16.123.19'
