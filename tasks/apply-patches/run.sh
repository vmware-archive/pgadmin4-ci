#!/usr/bin/env bash

set -e

dir=$PWD

pushd pgadmin-repo > /dev/null
  oldSHA=$(git rev-parse HEAD)

  git \
    apply \
    $dir/patches/attachments/*

  git add -A

  git \
    -c user.name=pgadmin-bot \
    -c user.email=pgadmin-bot@pivotal.io \
    commit \
    -m 'Applied patch from CI'

  code_quotes='```'

  cat > metadata.txt <<EOF
*$(< $dir/patches/from) - $(< $dir/patches/subject)*
$(cut -c 1-150 < $dir/patches/body )...
${code_quotes}
$(git diff ..$oldSHA --stat)
${code_quotes}
$(cd $dir/patches/attachments && ls )
EOF

  cat metadata.txt
popd > /dev/null

tar -czf artifacts/pgadmin-repo.tgz pgadmin-repo
