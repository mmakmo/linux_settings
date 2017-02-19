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

# install python environments
echo $1 | sudo -S aptitude update -y
echo $1 | sudo -S aptitude install -y neovim python-dev python-pip
echo $1 | sudo -S pip install --upgrade pip
echo $1 | sudo -S pip install --upgrade virtualenv
echo $1 | sudo -S pip install --upgrade virtualenvwrapper

git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
echo '
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source /usr/local/bin/virtualenvwrapper.sh' >> ~/.profile

echo "# Virtualenvwrapper" >> ~/.profile
echo "if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then" >> ~/.profile
echo "    export WORKON_HOME='$HOME/.virtualenvs'" >> ~/.profile
echo "    source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile
echo "fi" >> ~/.profile

echo "export XDG_CONFIG_HOME=~/.config" >> ~/.profile


#pyenv install anaconda3-4.3.0
#pyenv global anaconda3-4.3.0

# cleanup
echo $1 | sudo -S aptitude autoclean
source ~/.bashrc
source ~/.profile
