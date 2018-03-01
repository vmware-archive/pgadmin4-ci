#!/usr/bin/env bash
set -e

PIVOTAL_SOURCE=$1

pip install pycodestyle

pushd $PIVOTAL_SOURCE/web
  pycodestyle --config=.pycodestyle .
  ERROR=$?
popd

exit $ERROR
