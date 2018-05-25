#!/usr/bin/env bash

set -e

PIVOTAL_SOURCE=pgadmin-repo

tar -xf pgadmin-repo-tarball/*.tgz

chown -R postgres:postgres /var/lib/postgresql/data
/opt/bin/postgres_start.sh
trap /opt/bin/postgres_stop.sh exit

# Pass in the config file
cp pgadmin-ci/config_local.py $PIVOTAL_SOURCE/web/config_local.py
#cp pgadmin-ci/test_config.json $PIVOTAL_SOURCE/web/regression/test_config.json
sed -e "s/{{db_name}}/PostgreSQL/" \
    -e "s/{{db_comment}}/Concourse default postgres/" \
    -e "s/{{db_host}}/localhost/" \
    -e "s/{{db_username}}/postgres/" \
    -e "s/{{db_password}}//" \
    -e "s/{{db_port}}/5432/" \
    -e "s/{{db_version}}/$PG_MAJOR/" \
    pgadmin-ci/test_config.template.json \
  > $PIVOTAL_SOURCE/web/regression/test_config.json

# Replace the first line of the file with the missing import
sed -i '/__future__/a from selenium.webdriver.common.desired_capabilities import DesiredCapabilities' $PIVOTAL_SOURCE/web/regression/runtests.py
sed -i "s/Chrome()/Remote\(command_executor='http:\/\/127.0.0.1:4444\/wd\/hub', desired_capabilities=DesiredCapabilities.CHROME\)/" $PIVOTAL_SOURCE/web/regression/runtests.py

mkdir logs
/opt/bin/start_selenium.sh &

# the shell we're in is probably not a login shell in concourse
source ~/.bash_profile
pyenv activate $PYENV_ENV

## Install project requirements
pip install -r $PIVOTAL_SOURCE/requirements.txt
pip install -r $PIVOTAL_SOURCE/web/regression/requirements.txt

cd $PIVOTAL_SOURCE/web
yarn install --no-progress

PYTHONPATH=$PIVOTAL_SOURCE/web

if [[ -n $(which pytest) ]]; then
  pytest -q pgadmin
else
  python regression/runtests.py
fi
