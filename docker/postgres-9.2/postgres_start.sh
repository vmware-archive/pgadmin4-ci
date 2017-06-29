#!/usr/bin/env bash

set -e

gosu postgres initdb
gosu postgres pg_ctl -D /var/lib/postgresql/data start