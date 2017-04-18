#!/usr/bin/env bash

branch_name=`git log -1 --oneline | cut -d "[" -f2 | cut -d "]" -f1`

if [[ "$branch_name" =~ \ |\' ]]    #  slightly more readable: if [[ "$string" =~ ( |\') ]]
then
    echo "Not deploying because couldn't find the branch name in the git message: '$branch_name'"
    exit 0
fi

cf login -a api.run.pivotal.io -u $CF_USER_NAME -p $CF_USER_PASSWORD -s plumadmin

cp config_local_cf.py submodules/plummaster/web/config_local.py
cp .cfignore submodules/plummaster/web/

pushd submodules/plummaster
    cf push plumadmin-$branch_name -f ../../manifest.yml
popd

exit 0