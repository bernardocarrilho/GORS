#!/bin/bash

./cleanup.sh
scp -r ./quagga -F vmC:/home/theuser/
scp -r ./prefix_hijacking.sh -F vmC:/home/theuser/
ssh vmC './prefix_hijacking.sh'
