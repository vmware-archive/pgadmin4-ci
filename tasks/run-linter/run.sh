#!/usr/bin/env bash

set -e

tar -xf pgadmin-repo-tarball/*.tgz
pyenv activate pgadmin36

cd pgadmin-repo/web
pip install -r regression/requirements.txt

yarn install --no-progress
yarn pep8
yarn linter
