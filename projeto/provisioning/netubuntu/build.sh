#!/bin/bash

scp -r ./baseimage -F vmC:/home/theuser/
ssh vmC 'sudo docker build --tag netubuntu:latest ~/baseimage'
