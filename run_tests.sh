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

python --version

pip install -r ./submodules/plummaster/requirements.txt

python ./submodules/master/web/regression/runtests.py
python ./submodules/plummaster/web/regression/runtests.py