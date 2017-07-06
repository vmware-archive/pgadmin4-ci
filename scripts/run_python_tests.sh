#!/usr/bin/env bash

set -e

PIVOTAL_SOURCE=$1

/opt/bin/postgres_start.sh

echo "This is:"
gosu postgres psql -c 'select version();'

# Pass in the config file
cp pipeline-ci/config_local.py $PIVOTAL_SOURCE/web/config_local.py
cp pipeline-ci/test_config.json $PIVOTAL_SOURCE/web/regression/test_config.json

# Replace the first line of the file with the missing import
sed -i '/__future__/a from selenium.webdriver.common.desired_capabilities import DesiredCapabilities' $PIVOTAL_SOURCE/web/regression/runtests.py
sed -i "s/Chrome()/Remote\(command_executor='http:\/\/127.0.0.1:4444\/wd\/hub', desired_capabilities=DesiredCapabilities.CHROME\)/" $PIVOTAL_SOURCE/web/regression/runtests.py

mkdir logs
/opt/bin/start_selenium.sh &

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
    /opt/bin/postgres_stop.sh
    set -e
    return $status
}

runTests
