#!/usr/bin/env bash
set -e

PIVOTAL_SOURCE=$1


pushd $PIVOTAL_SOURCE/web
  pip install -r regression/requirements.txt
  pycodestyle --config=.pycodestyle .
  ERROR=$?
popd

exit $ERROR
