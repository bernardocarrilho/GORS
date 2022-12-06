#!/bin/bash

ssh vmC "sudo docker exec org1_router1 /bin/bash -c 'ip link set eth2 up'"
