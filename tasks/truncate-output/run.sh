#!/usr/bin/env bash

# This script is intended to limit the amount of logs
# shown on the concourse dashboard so that the UI
# does not become too sluggish when interacting with
# verbose tasks

script=$1
log_file=$PWD/build.log

function showLogs {
    tail -n 200 $log_file
}

trap showLogs EXIT

$script > $log_file 2>&1