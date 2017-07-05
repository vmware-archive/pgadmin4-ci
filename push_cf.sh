#!/usr/bin/env bash

pushd ~/workspace/pgadmin4
  branch_name=`git branch|grep '\*' |awk '{print $2}'`
popd

if [[ "$branch_name" =~ \ |\' ]]    #  slightly more readable: if [[ "$string" =~ ( |\') ]]
then
    echo "Not deploying because couldn't find the branch name in the git message: '$branch_name'"
    exit 0
fi

cf login -a api.run.pivotal.io -u $CF_USER_NAME -p $CF_USER_PASSWORD -s plumadmin

cp config_local_cf.py submodules/plummaster/web/config_local.py
cp .cfignore submodules/plummaster/web/
cp manifest.yml submodules/plummaster/
cp submodules/plummaster/requirements.txt submodules/plummaster/web/

pushd submodules/plummaster
  git checkout $branch_name

  pushd web
    yarn install
    yarn run bundle
  popd

  cf push plumadmin-$branch_name -f manifest.yml
popd

exit 0
