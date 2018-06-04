#!/usr/bin/env bash

set -e

PIVOTAL_SOURCE=pgadmin-repo

tar -xf pgadmin-repo-tarball/*.tgz

# Pass in the config file
cp pgadmin-ci/config_local.py $PIVOTAL_SOURCE/web/config_local.py
sed -e "s/{{db_name}}/GreenPlum5/" \
    -e "s/{{db_comment}}/Greenplum Pivotal Server/" \
    -e "s/{{db_host}}/$GPDB_HOST/" \
    -e "s/{{db_username}}/$GPDB_USERNAME/" \
    -e "s/{{db_password}}/$GPDB_PASSWORD/" \
    -e "s/{{db_port}}/$GPDB_PORT/" \
    -e "s/{{db_version}}/0/" \
    pgadmin-ci/test_config.template.json \
  > $PIVOTAL_SOURCE/web/regression/test_config.json

# Replace the first line of the file with the missing import
sed -i '/__future__/a from selenium.webdriver.common.desired_capabilities import DesiredCapabilities' $PIVOTAL_SOURCE/web/regression/runtests.py
sed -i "s/Chrome()/Remote\(command_executor='http:\/\/127.0.0.1:4444\/wd\/hub', desired_capabilities=DesiredCapabilities.CHROME\)/" $PIVOTAL_SOURCE/web/regression/runtests.py

mkdir logs
/opt/bin/start_selenium.sh &

sudo su - gp /bin/bash -c /home/gp/install_and_start_gpdb.sh

# the shell we're in is probably not a login shell in concourse
source ~/.bash_profile
pyenv activate pgadmin

## Install project requirements
pip install -r $PIVOTAL_SOURCE/requirements.txt
pip install -r $PIVOTAL_SOURCE/web/regression/requirements.txt

cd $PIVOTAL_SOURCE/web
yarn install --no-progress

export PYTHONPATH=`pwd`

if [[ -n $(which pytest) ]]; then
  pytest -q pgadmin regression/feature_tests
else
  python regression/runtests.py
fi
