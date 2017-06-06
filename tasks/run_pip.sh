#!/bin/bash
pip -v
pip install -r pivotal-source/requirements.txt

./pipeline-ci/tasks/install_linux_packages.sh

cd ./pivotal-source/web/
yarn
yarn run karma start -- --single-run