#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
PIPELINE=${1:-pgadmin-patch}

fly \
  -t ci \
  set-pipeline \
  -p $PIPELINE \
  -c $DIR/pipelines/$PIPELINE.yml \
  -l <(lpass show --notes "Shared-Data GPDB/pgadmin-ci-secrets")