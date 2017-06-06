#!/bin/bash
#pip install -r pivotal-source/requirements.txt
#pip install -r pivotal-source/web/regression/requirements.txt

#./pipeline-ci/tasks/install_linux_packages.sh

cd ./pivotal-source/web/
yarn
yarn run karma start -- --single-run