#!/usr/bin/env bash
set -e

pushd ~/workspace/pgadmin4
  branch_name=`git branch|grep '\*' |awk '{print $2}'`
popd

if [[ "$branch_name" =~ \ |\' ]]    #  slightly more readable: if [[ "$string" =~ ( |\') ]]
then
    echo "Not deploying because couldn't find the branch name in the git message: '$branch_name'"
    exit 0
fi

# cf login -a api.run.pivotal.io -u $CF_USER_NAME -p $CF_USER_PASSWORD -s plumadmin

cp config_local_cf.py ~/workspace/pgadmin4/web/config_local.py
cp .cfignore ~/workspace/pgadmin4/web/
cp manifest.yml ~/workspace/pgadmin4/
cp ~/workspace/pgadmin4/requirements.txt ~/workspace/pgadmin4/web/

pushd ~/workspace/pgadmin4
  pushd web
    yarn install
    yarn run bundle
  popd

  cf push plumadmin-$branch_name -f manifest.yml
popd

exit 0
