#!/usr/bin/env bash

pip install -r pivotal-source/requirements.txt
pip install -r pivotal-source/web/regression/requirements.txt

sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
apt-get update
apt-get -y install postgresql postgresql-contrib

sed -i s/md5/trust/ /etc/postgresql/9.6/main/pg_hba.conf

/etc/init.d/postgresql restart

python ./pivotal-source/web/regression/runtests.py