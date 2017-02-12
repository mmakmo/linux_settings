#!/usr/bin/env bash

# install basic packages
apt install -y aptitude
aptitude update -y
aptitude upgrade -y
aptitude install -y ssh tmux

# install development tools
aptitude install -y git bats vim

# cleanup
aptitude autoclean
