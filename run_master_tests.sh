#!/usr/bin/env bash

pushd ./submodules/plummaster/web/
    yarn
    yarn run karma start -- --single-run
popd

python ./submodules/master/web/regression/runtests.py
