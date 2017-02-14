#!/usr/bin/env bash

# install basic packages
apt install -y aptitude
aptitude update -y
aptitude upgrade -y
aptitude install -y ssh tmux

# install development tools
aptitude install -y git bats vim

# install neovim
aptitude install -y software-properties-common
add-apt-repository -y ppa:neovim-ppa/unstable
aptitude update -y
aptitude install -y neovim python3-dev python3-pip
pip3 install -U pip3
pip3 install --upgrade pip

# cleanup
echo "export XDG_CONFIG_HOME=~/.config" >> ~/.bashrc
aptitude autoclean
