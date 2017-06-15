#!/bin/bash

PIVOTAL_SOURCE=$1

cd $PIVOTAL_SOURCE/web
yarn
yarn run karma start -- --single-run