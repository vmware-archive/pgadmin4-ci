#!/usr/bin/env bash
case $CIRCLE_NODE_INDEX in
    0)
        pyenv global 2.7.12
    ;;
    1)
        pyenv global 3.1.5
    ;;
    2)
        pyenv global 3.2.6
    ;;
    3)
        pyenv global 3.5.2
    ;;
esac

pip install -r ./submodules/plummaster/requirements.txt

python ./submodules/master/web/regression/runtests.py
python ./submodules/plummaster/web/regression/runtests.py