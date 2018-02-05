#!/usr/bin/env bash
set -e

branch_name=$1

# Copy files needed for pcf to run pgAdmin4
cp pipeline-ci/config_local_cf.py $PIVOTAL_SOURCE/web/config_local.py
cp pipeline-ci/.cfignore $PIVOTAL_SOURCE/web/
cp pipeline-ci/manifest.yml $PIVOTAL_SOURCE/
cp $PIVOTAL_SOURCE/requirements.txt $PIVOTAL_SOURCE/web/

pushd $PIVOTAL_SOURCE
  # Webpack all the things
  pushd web
    yarn install
    yarn run bundle
  popd
popd

exit 0
