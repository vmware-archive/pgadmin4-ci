#!/bin/bash

PIVOTAL_SOURCE=$1

set -e

cd $PIVOTAL_SOURCE/web
yarn install --no-progress
yarn run karma start --single-run
