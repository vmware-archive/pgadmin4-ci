#!/usr/bin/env bash
set -e

sed -e "s/GREENPLUM_DB_HOST/${GREENPLUM_DB_HOST}/g" \
    -e "s/GREENPLUM_DB_USERNAME/${GREENPLUM_DB_USERNAME}/g" \
    -e "s/GREENPLUM_DB_PASSWORD/${GREENPLUM_DB_PASSWORD}/g" \
    -e "s/GREENPLUM_DB_PORT/${GREENPLUM_DB_PORT}/g" \
    test_config.template.json > ./submodules/plummaster/web/regression/test_config.json

python ./submodules/plummaster/web/regression/runtests.py --pkg feature_tests
