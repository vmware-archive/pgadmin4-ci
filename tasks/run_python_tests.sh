#!/usr/bin/env bash

pip install -r pivotal-source/requirements.txt
pip install -r pivotal-source/web/regression/requirements.txt

python ./pivotal-source/web/regression/runtests.py