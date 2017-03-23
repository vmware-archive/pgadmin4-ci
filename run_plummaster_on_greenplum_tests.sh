#!/usr/bin/env bash
set -e

sed -e "s/SERVER_CONFIGURATION/${GREENPLUM_CONFIGURATION}/g" test_config.template.json > ./submodules/plummaster/web/regression/test_config.json

python ./submodules/plummaster/web/regression/runtests.py --pkg feature_tests
