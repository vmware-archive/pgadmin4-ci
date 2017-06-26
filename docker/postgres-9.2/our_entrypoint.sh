#!/usr/bin/env sh

gosu postgres initdb
gosu postgres pg_ctl -D /var/lib/postgresql/data start