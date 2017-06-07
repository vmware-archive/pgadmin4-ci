#!/usr/bin/env bash

apt-get update

# Install project requirements
pip install -r pivotal-source/requirements.txt
pip install -r pivotal-source/web/regression/requirements.txt

# Install postgres
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
apt-get -y install postgresql postgresql-contrib

# Configure our instance of postgres
sed -i s/md5/trust/ /etc/postgresql/9.6/main/pg_hba.conf
/etc/init.d/postgresql restart

# Install chrome
apt-get -y remove google-chrome-stable
apt-get -y install xvfb chromium
cp pipeline-ci/tasks/xvfb-chromium /usr/bin/xvfb-chromium
ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome
ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser

# Run all python tests. Includes feature tests.
python ./pivotal-source/web/regression/runtests.py