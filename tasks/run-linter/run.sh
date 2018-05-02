#!/usr/bin/env bash

set -e

tar -xf pgadmin-repo-tarball/*.tgz

cd pgadmin-repo/web
pip install -r regression/requirements.txt
pycodestyle --config=.pycodestyle .

yarn install --no-progress
yarn linter