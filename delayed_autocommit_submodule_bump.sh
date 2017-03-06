#!/usr/bin/env bash
# This should be invoked by the pgadmin4/.git/hooks/pre-push hook

set -euxo pipefail
echo 'Resting before commit to pgadmin4-CI'

sleep 10

git submodule update --init

pushd submodules/plummaster
  git fetch
  git reset --hard origin/plummaster
  CHILD_SHA=$(git rev-parse HEAD)
  CHILD_MESSAGE=$(git log --format=%B -n 1 HEAD)
popd

pushd submodules/master
  git fetch
  git reset --hard origin/master
  MASTER_CHILD_SHA=$(git rev-parse HEAD)
  MASTER_CHILD_MESSAGE=$(git log --format=%B -n 1 HEAD)
popd

git add submodules/plummaster
git add submodules/master
git commit -m "Auto-update plummaster to \"$CHILD_MESSAGE\"($CHILD_SHA)

- also bump master to \"$MASTER_CHILD_MESSAGE\"($MASTER_CHILD_SHA)"

git push

