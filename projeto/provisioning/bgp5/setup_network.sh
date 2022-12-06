#!/bin/bash

# public networks
sudo docker network create public_net1 --subnet=172.31.255.0/27 --gateway=172.31.255.1
sudo docker network create public_net2 --subnet=172.31.255.32/27 --gateway=172.31.255.33
sudo docker network create public_net3 --subnet=172.31.255.64/27 --gateway=172.31.255.65
sudo docker network create public_net4 --subnet=172.31.255.96/27 --gateway=172.31.255.97
sudo docker network create public_net5 --subnet=172.31.255.128/27 --gateway=172.31.255.129
sudo docker network create public_net6 --subnet=172.31.255.160/27 --gateway=172.31.255.161

# org1 nets
sudo docker network create org1_pub1_net --subnet=172.16.123.0/28 --gateway=172.16.123.1
sudo docker network create org1_int1_net --subnet=10.0.1.0/29 --gateway=10.0.1.1

# org2 nets
sudo docker network create org2_int1_net --subnet=10.0.2.0/29 --gateway=10.0.2.1

# org3 nets
sudo docker network create org3_int1_net --subnet=10.0.3.0/29 --gateway=10.0.3.1

# org4 nets
sudo docker network create org4_int1_net --subnet=10.0.4.0/29 --gateway=10.0.4.1

# org5 nets
sudo docker network create org5_int1_net --subnet=10.0.5.0/29 --gateway=10.0.5.1
#sudo docker network create org5_int2_net --subnet=10.0.5.8/29 --gateway=10.0.5.9
#sudo docker network create org5_int3_net --subnet=10.0.5.16/29 --gateway=10.0.5.17
#sudo docker network create org5_int4_net --subnet=10.0.5.24/29 --gateway=10.0.5.25
sudo docker network create org5_pub1_net --subnet=172.16.123.64/28 --gateway=172.16.123.65

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
sudo docker network connect public_net3 org1_router1 --ip 172.31.255.66
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
sudo docker network connect public_net5 org2_router1 --ip 172.31.255.130
sudo docker exec org2_router1 /bin/bash -c 'ip r del default via 10.0.2.1'


# org3 routers
echo ">>>>R3.1"
sudo docker run --rm -d --net org3_int1_net --ip 10.0.3.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org3.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org3_router1 netubuntu 
sudo docker network connect public_net3 org3_router1 --ip 172.31.255.67
sudo docker network connect public_net4 org3_router1 --ip 172.31.255.98
sudo docker exec org3_router1 /bin/bash -c 'ip r del default via 10.0.3.1'


# org4 routers
echo ">>>>R4.1"
sudo docker run --rm -d --net org4_int1_net --ip 10.0.4.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org4.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org4_router1 netubuntu 
sudo docker network connect public_net2 org4_router1 --ip 172.31.255.35
sudo docker network connect public_net6 org4_router1 --ip 172.31.255.162
sudo docker exec org4_router1 /bin/bash -c 'ip r del default via 10.0.4.1'


# org5 routers
echo ">>>>R5.1"
sudo docker run --rm -d --net org5_int1_net --ip 10.0.5.2 \
    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/theuser/quagga/bgpd-org5.conf:/etc/quagga/bgpd.conf \
    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name org5_router1 netubuntu 
sudo docker network connect public_net5 org5_router1 --ip 172.31.255.131
sudo docker network connect public_net4 org5_router1 --ip 172.31.255.99
sudo docker network connect public_net6 org5_router1 --ip 172.31.255.163
sudo docker network connect org5_pub1_net org5_router1 --ip 172.16.123.67
sudo docker exec org5_router1 /bin/bash -c 'ip r del default via 10.0.5.1'

#echo ">>>>R5.2"
#sudo docker run --rm -d --net org5_int3_net --ip 10.0.5.18 \
#    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
#    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
#    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
#    --cap-add=NET_ADMIN  --privileged --name org5_router2 netubuntu 
#sudo docker network connect public_net5 org5_router2 --ip 172.31.255.131
#sudo docker network connect org5_int1_net org5_router2 --ip 10.0.5.3
#sudo docker exec org5_router2 /bin/bash -c 'ip r del default via 10.0.5.17'

#echo ">>>>R5.3"
#sudo docker run --rm -d --net org5_int2_net --ip 10.0.5.11 \
#    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
#    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
#    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
#    --cap-add=NET_ADMIN  --privileged --name org5_router3 netubuntu 
#sudo docker network connect public_net6 org5_router3 --ip 172.31.255.163
#sudo docker network connect org5_int4_net org5_router3 --ip 10.0.5.26
#sudo docker exec org5_router1 /bin/bash -c 'ip r del default via 10.0.5.9'

#echo ">>>>R5.4"
#sudo docker run --rm -d --net org5_int4_net --ip 10.0.5.27 \
#    -v /home/theuser/quagga/zebra.conf:/etc/quagga/zebra.conf \
#    -v /home/theuser/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
#    -v /home/theuser/quagga/start-ospf-bgp.sh:/root/start.sh \
#    --cap-add=NET_ADMIN  --privileged --name org5_router4 netubuntu 
#sudo docker network connect org5_pub1_net org5_router4 --ip 172.16.123.67
#sudo docker network connect org5_int3_net org5_router4 --ip 10.0.5.19
#sudo docker exec org5_router1 /bin/bash -c 'ip r del default via 10.0.5.25'



echo ">>>>S1.1"
sudo docker run --rm -d --net org1_pub1_net --ip 172.16.123.2 --cap-add=NET_ADMIN --name org1_server1 netubuntu 
sudo docker exec org1_server1 /bin/bash -c 'ip r del default via 172.16.123.1'
sudo docker exec org1_server1 /bin/bash -c 'ip r add default via 172.16.123.3'

echo ">>>>S5.1"
sudo docker run --rm -d --net org5_pub1_net --ip 172.16.123.66 --cap-add=NET_ADMIN --name org5_server1 netubuntu 
sudo docker exec org5_server1 /bin/bash -c 'ip r del default via 172.16.123.65'
sudo docker exec org5_server1 /bin/bash -c 'ip r add default via 172.16.123.67'
