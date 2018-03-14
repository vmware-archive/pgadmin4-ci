#!/usr/bin/env bash

set -xe

PIVOTAL_SOURCE=$1
GPDB_HOST=$2
GPDB_USERNAME=$3
GPDB_PASSWORD=$4
GPDB_PORT=$5

# Pass in the config file
cp pipeline-ci/config_local.py $PIVOTAL_SOURCE/web/config_local.py
sed -e "s/{{greenplum_db_host}}/$GPDB_HOST/" \
    -e "s/{{greenplum_db_username}}/$GPDB_USERNAME/" \
    -e "s/{{greenplum_db_password}}/$GPDB_PASSWORD/" \
    -e "s/{{greenplum_db_port}}/$GPDB_PORT/" pipeline-ci/test_config.greenplum.json \
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

pushd $PIVOTAL_SOURCE/web
yarn install --no-progress
popd

function runTests {
    set +e
    python $PIVOTAL_SOURCE/web/regression/runtests.py
    status=$?
    set -e
    return $status
}

runTests
