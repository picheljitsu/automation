#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade
apt-get install snap
sed -i '/#PermitRootLogin\s.../

