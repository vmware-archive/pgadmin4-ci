#!/bin/bash
pip -v
pip install -r pivotal-source/requirements.txt

./pipeline-ci/tasks/install_linux_packages.sh

pushd ./pivotal-source/web/
    yarn
    yarn run karma start -- --single-run
popd