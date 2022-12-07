# Folder Contents:
- *quagga/* -> Quagga configuration files and scripts.
- *setup_network.sh* -> Script to set up the docker networks and containers.
- *prefix_hijacking.sh* -> Same as *setup_network.sh*, but to demonstrate prefix hijacking scenario.
- *run.sh* -> Script to transfer *quagga/* and *setup_network.sh* to the target VM and run *setup_network.sh*.
- *run_ph.sh* -> Same as *run.sh*, but to set up the prefix hijacking scenario.
- *cleanup.sh* -> Script to remove all created docker networks and containers on the target VM.
- *run_link_down.sh* -> Script to set the link from AS100 to AS200 down.
- *run_link_up.sh* -> Script to set link from AS100 to AS200 up.


# Instructions:
Run run.sh or run_ph.sh to cleanup the target vm and setup the network.\
To test that the network is performing correctly, use the following commands:

$ sudo docker exec org1_router1 /bin/bash -c 'vtysh -c "show ip bgp"'\
$ sudo docker exec org1_router1 /bin/bash -c 'vtysh -c "show ip route"'\
$ sudo docker exec org1_router1 /bin/bash -c 'vtysh -c "show bgp neighbors"'

$ sudo docker exec org1_server1 /bin/bash -c 'ping 172.16.123.18'\
$ sudo docker exec org4_server1 /bin/bash -c 'ping 172.16.123.2'
