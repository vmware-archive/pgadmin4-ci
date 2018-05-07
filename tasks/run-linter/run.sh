#!/usr/bin/env bash

set -e

tar -xf pgadmin-repo-tarball/*.tgz

# the shell we're in is probably not a login shell in concourse
source ~/.bash_profile
pyenv activate pgadmin36

cd pgadmin-repo/web
pip install -r regression/requirements.txt

yarn install --no-progress
yarn pep8
yarn linter
