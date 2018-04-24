#!/usr/bin/env bash

set -e

tar -xf pgadmin-repo-tarball/*.tgz

cd pgadmin-repo/web
yarn install --no-progress
yarn run karma start --single-run
