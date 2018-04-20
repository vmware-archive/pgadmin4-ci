#!/usr/bin/env bash

set -e

dir=$PWD

pushd pgadmin-repo > /dev/null
oldSHA=$(git rev-parse HEAD)

git \
  apply \
  $dir/patches/attachments/*

git \
  -c user.name=pgadmin-bot \
  -c user.email=pgadmin-bot@pivotal.io \
  commit \
  -am 'Applied patch from CI'

  cat > metadata.txt <<EOF
*$(< $dir/patches/subject)*
\\`\\`\\`
$(git diff ..$oldSHA --stat)
\\`\\`\\`
$(ls $dir/patches/attachments/* |  xargs basename )
EOF

  cat metadata.txt
popd > /dev/null

tar -czf artifacts/pgadmin-repo.tgz pgadmin-repo
