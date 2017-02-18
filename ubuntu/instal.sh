#!/usr/bin/env bash

# install basic packages
apt install -f -y aptitude
aptitude update -y
aptitude upgrade -y
aptitude install -y ssh tmux

# install development tools
aptitude install -y git bats vim

# install neovim
aptitude install -y software-properties-common
add-apt-repository -y ppa:neovim-ppa/unstable

# install python environments
aptitude update -y
aptitude install -y neovim python-dev python-pip
pip install --upgrade pip
pip install --upgrade virtualenv
pip install --upgrade virtualenvwrapper

git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
echo '
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
"source /usr/local/bin/virtualenvwrapper.sh"' >> ~/.profile

echo "# Virtualenvwrapper" >> ~/.profile
echo "if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then" >> ~/.profile
echo "    export WORKON_HOME='$HOME/.virtualenvs'" >> ~/.profile
echo "    source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile
echo "fi" >> ~/.profile

echo "export XDG_CONFIG_HOME=~/.config" >> ~/.profile


#pyenv install anaconda3-4.3.0
#pyenv global anaconda3-4.3.0

# cleanup
aptitude autoclean
source ~/.bashrc
source ~/.profile
