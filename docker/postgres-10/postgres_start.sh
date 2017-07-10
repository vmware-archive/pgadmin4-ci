#!/usr/bin/env bash

set -e

gosu postgres initdb
gosu postgres pg_ctl -D /var/lib/postgresql/data start
sleep 5

echo
echo "This should be postgres 10beta1"
echo
