#!/usr/bin/env bash

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile

source ~/.bash_profile

git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
source ~/.bash_profile

pyenv install 2.7.10
pyenv virtualenv 2.7.10 pgadmin
pyenv install 3.1.5
pyenv virtualenv 3.1.5 pgadmin31
pyenv install 3.2.6
pyenv virtualenv 3.2.6 pgadmin32
pyenv install 3.3.7
pyenv virtualenv 3.3.7 pgadmin33
pyenv install 3.4.8
pyenv virtualenv 3.4.8 pgadmin34
pyenv install 3.5.5
pyenv virtualenv 3.5.5 pgadmin35
pyenv install 3.6.4
pyenv virtualenv 3.6.4 pgadmin36
pyenv activate pgadmin36


pyenv activate pgadmin
