#!/usr/bin/env sh

set -e

gosu postgres initdb
gosu postgres pg_ctl -D /var/lib/postgresql/data start