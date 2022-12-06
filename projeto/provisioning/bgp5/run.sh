#!/bin/bash

scp -r ./quagga -F vmC:/home/theuser/
scp -r ./setup_network.sh -F vmC:/home/theuser/
ssh vmC './setup_network.sh'
