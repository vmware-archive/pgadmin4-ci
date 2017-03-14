#!/usr/bin/env bash

case $CIRCLE_NODE_INDEX in
    0)
        pyenv global 2.7.12
    ;;
    1)
        pyenv global 3.3.6
    ;;
    2)
        pyenv global 3.5.2
    ;;
    3)
        pyenv global 3.6.0
    ;;
esac

sudo apt-get install xsel

python --version

pip install -r ./submodules/plummaster/requirements.txt
pip install -r ./submodules/plummaster/web/regression/requirements.txt
