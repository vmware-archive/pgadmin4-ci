#!/usr/bin/env bash

INPUT_DIR=$1
OUTPUT_DIR=$2

cd $INPUT_DIR/web

yarn install --no-progress
yarn webpacker

cd -
cp -r $INPUT_DIR/* $OUTPUT_DIR