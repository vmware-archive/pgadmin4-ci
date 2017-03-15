#!/usr/bin/env bash

python ./submodules/plummaster/web/regression/runtests.py

pushd ./submodules/plummaster/web/
    yarn
    yarn run karma start
popd
