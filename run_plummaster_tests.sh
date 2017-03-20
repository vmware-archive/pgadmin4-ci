#!/usr/bin/env bash
set -e

pushd ./submodules/plummaster/web/
    yarn
    yarn run karma start
popd

python ./submodules/plummaster/web/regression/runtests.py
