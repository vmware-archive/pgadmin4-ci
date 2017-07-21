#!/usr/bin/env bash

set -e

source /usr/local/gpdb/greenplum_path.sh
export MASTER_DATA_DIRECTORY=/usr/local/share/gpdb
export USER=gpadmin
#/opt/bin/initialize_gpdb.sh
gosu gpadmin gpstart -a

sleep 5

echo
echo "This should be gpdb 5 beta3"
echo