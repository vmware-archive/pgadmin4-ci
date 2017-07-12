#!/usr/bin/env bash

set -e

chown postgres -R /var/run/postgresql

gosu postgres initdb
gosu postgres pg_ctl -D /var/lib/postgresql/data start
sleep 5

echo
echo "This should be postgres 9.2"
echo