#!/bin/bash

ssh vmC 'sudo docker kill `sudo docker ps -aq`'
ssh vmC 'sudo docker network prune -f'
ssh vmC 'sudo rm -r ~/quagga/'
ssh vmC 'sudo rm ~/setup_network.sh'
ssh vmC 'sudo rm ~/prefix_hijacking.sh'
