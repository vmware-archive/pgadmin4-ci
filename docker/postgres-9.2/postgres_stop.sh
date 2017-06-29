#!/usr/bin/env sh

set -e

gosu postgres pg_ctl -D /var/lib/postgresql/data stop