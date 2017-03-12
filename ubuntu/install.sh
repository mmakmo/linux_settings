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

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(readlink "$name" || true)"
  done

  pwd -P
  cd "$cwd"
}

SCRIPT_DIR="$(abs_dirname "$0")"
SUDO_PW=$1


# install basic packages
echo $SUDO_PW | sudo -S apt install -f -y aptitude
echo $SUDO_PW | sudo -S aptitude update -y
echo $SUDO_PW | sudo -S aptitude upgrade -y
echo $SUDO_PW | sudo -S aptitude install -y ssh tmux


# install development tools
echo $SUDO_PW | sudo -S aptitude install -y git bats vim mysql-client libmysqlclient-dev

# install docker
echo $SUDO_PW | sudo -S aptitude install -y apt-transport-https ca-certificates curl software-properties-common
echo $SUDO_PW | curl -fsSL https://apt.dockerproject.org/gpg | sudo -S apt-key add -
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
echo $SUDO_PW | sudo -S add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"
echo $SUDO_PW | sudo -S aptitude update
echo $SUDO_PW | sudo -S aptitude install -y docker-engine

# install neovim
echo $SUDO_PW | sudo -S aptitude install -y software-properties-common
echo $SUDO_PW | sudo -S add-apt-repository -y ppa:neovim-ppa/unstable
echo $SUDO_PW | sudo -S aptitude update -y
echo $SUDO_PW | sudo -S aptitude install -y neovim
echo "export XDG_CONFIG_HOME=~/.config" >> $HOME/.profile


# install python environments
echo $SUDO_PW | sudo -S aptitude install -y \
                build-essential zlib1g-dev libbz2-dev libssl-dev \
                libreadline-dev libncurses5-dev libsqlite3-dev \
                libgdbm-dev libdb-dev libexpat-dev libpcap-dev \
                liblzma-dev libpcre3-dev curl python-pip \
                python3-dev python3-pip
curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
echo '[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc' >> $HOME/.bashrc

## install Golang
echo $SUDO_PW | sudo -S add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
echo $SUDO_PW | sudo -S aptitude update
echo $SUDO_PW | sudo -S aptitude install -y golang

## install forego
wget https://bin.equinox.io/c/ekMN3bCZFUn/forgo-stable-linux-amd64.deb
echo $SUDO_PW | sudo -S dpkg -i forgo-stable-linux-amd64.deb
rm forgo-stable-linux-amd64.deb


## install direnv
if [ -e $HOME/.cache/direnv ]; then
    rm -rf $HOME/.cache/direnv
fi
git clone https://github.com/direnv/direnv $HOME/.cache/direnv
cd $HOME/.cache/direnv
echo $SUDO_PW | sudo -S make install
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
cd $SCRIPT_DIR

## install pip and virtualenv
pip install --upgrade pip
pip3 install --upgrade pip
echo $SUDO_PW | sudo -S pip3 install --upgrade virtualenv
echo $SUDO_PW | sudo -S pip3 install --upgrade jedi
echo $SUDO_PW | sudo -S pip3 install --upgrade yapf
pip3 install --upgrade --user neovim
pip3 install --upgrade ipython

# add symbolic links
NEOVIM_CONF=$(cd $(dirname $0)/../linux/dotfiles/.config/nvim && pwd)
TMUX_CONF=$(cd $(dirname $0)/../linux/dotfiles/ && pwd)/.tmux.conf 
if [ -e $HOME/.config/nvim ]; then
    rm -rf $HOME/.config/nvim
fi
if [ -e $HOME/.tmux.conf ]; then
    rm $HOME/.tmux.conf
fi
ln -s $NEOVIM_CONF $HOME/.config/nvim
ln -s $TMUX_CONF $HOME/.tmux.conf 


# cleanup
echo $SUDO_PW | sudo -S aptitude autoclean
source ~/.bashrc
source ~/.profile
exec $SHELL
