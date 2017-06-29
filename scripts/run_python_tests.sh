#!/usr/bin/env bash

set -x

PIVOTAL_SOURCE=$1

/opt/bin/postgres_start.sh

# Configure our instance of postgres
#export PSQL_VERSION=`postgres -V | egrep -o '[0-9]{1,}\.[0-9]{1,}'`
#export PSQL_VERSION=9.2
#pg_createcluster $PSQL_VERSION main --start
#sed -i 's/peer/trust/' /etc/postgresql/$PSQL_VERSION/main/pg_hba.conf
#sed -i 's/md5/trust/' /etc/postgresql/$PSQL_VERSION/main/pg_hba.conf
#/etc/init.d/postgresql restart


# Pass in the config file
cp pipeline-ci/config_local.py $PIVOTAL_SOURCE/web/config_local.py
cp pipeline-ci/test_config.json $PIVOTAL_SOURCE/web/regression/test_config.json

# Replace the first line of the file with the missing import
sed -i '/__future__/a from selenium.webdriver.common.desired_capabilities import DesiredCapabilities' $PIVOTAL_SOURCE/web/regression/runtests.py
sed -i "s/Chrome()/Remote\(command_executor='http:\/\/127.0.0.1:4444\/wd\/hub', desired_capabilities=DesiredCapabilities.CHROME\)/" $PIVOTAL_SOURCE/web/regression/runtests.py

mkdir logs
/opt/bin/start_selenium.sh & 1>logs/selenium.out 2>logs/selenium.err

pyenv activate pgadmin

## Install project requirements
pip install -r $PIVOTAL_SOURCE/requirements.txt
pip install -r $PIVOTAL_SOURCE/web/regression/requirements.txt

function runTests {
    python $PIVOTAL_SOURCE/web/regression/runtests.py
    status=$?
    /opt/bin/postgres_stop.sh
    return $status
}

runTests