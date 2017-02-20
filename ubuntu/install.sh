#!/usr/bin/env bash
# $1 sudu password

# requre sudo password
if [ "$1" == "" ]; then
    echo "[warning] require sudo password parameter."
    exit 1
fi

# error trap
set -euo pipefail
trap "[ERROR] exited with errors." ERR

# install basic packages
echo $1 | sudo -S apt install -f -y aptitude
echo $1 | sudo -S aptitude update -y
echo $1 | sudo -S aptitude upgrade -y
echo $1 | sudo -S aptitude install -y ssh tmux

# install development tools
echo $1 | sudo -S aptitude install -y git bats vim

# install neovim
echo $1 | sudo -S aptitude install -y software-properties-common
echo $1 | sudo -S add-apt-repository -y ppa:neovim-ppa/unstable
echo $1 | sudo -S aptitude update -y
echo $1 | sudo -S aptitude install -y neovim
echo "export XDG_CONFIG_HOME=~/.config" >> $HOME/.profile

# install python environments
echo $1 | sudo -S aptitude install -y \
                      build-essential zlib1g-dev libbz2-dev libssl-dev \
                      libreadline-dev libncurses5-dev libsqlite3-dev \
                      libgdbm-dev libdb-dev libexpat-dev libpcap-dev \
                      liblzma-dev libpcre3-dev curl python-pip
curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
echo '[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc' >> $HOME/.bashrc

## install Golang
echo $1 | sudo -S add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
echo $1 | sudo -S aptitude update
echo $1 | sudo -S aptitude install -y golang

## install direnv
git clone https://github.com/direnv/direnv $HOME/.cache/direnv
cd $HOME/.cache/direnv
echo $1 | sudo -S make install

## install pip and virtualenv
echo $1 | sudo -S pip install --upgrade pip
echo $1 | sudo -S pip install --upgrade virtualenv

# cleanup
echo $1 | sudo -S aptitude autoclean
source ~/.bashrc
source ~/.profile
exec $SHELL
