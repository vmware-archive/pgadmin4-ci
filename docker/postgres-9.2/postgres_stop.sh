#!/usr/bin/env bash

set -e

gosu postgres pg_ctl -D /var/lib/postgresql/data stop