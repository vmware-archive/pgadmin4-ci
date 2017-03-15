#!/usr/bin/env bash

pushd ./submodules/plummaster/web/
    yarn
    yarn run karma start
popd

python ./submodules/plummaster/web/regression/runtests.py
