#!/usr/bin/env bash

set -e

gosu postgres initdb

chmod a+w /tmp

gosu postgres pg_ctl -D /var/lib/postgresql/data start
sleep 5

echo
echo "This should be postgres 10beta2"
echo
