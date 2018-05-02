# currently published as pivotaldata/pgadmin:base-python-3.6-selenium-chrome
FROM selenium/node-chrome:latest

USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# chrome and yarn apt repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
 && wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && sh -c 'echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list' \
 && apt-get update

# copy utility for pyperclip to work in the test
RUN apt-get -y install xsel

# install node, yarn, postgres client library, python, pip and SQlite
RUN wget -q -O - https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get -y install nodejs yarn libpq-dev python python-dev git build-essential bzip2 libreadline6 sqlite3 libsqlite3-dev \
 && wget https://bootstrap.pypa.io/get-pip.py \
 && python get-pip.py

COPY pyenv_installation.sh /tmp/pyenv_installation.sh
COPY start_selenium.sh /opt/bin/start_selenium.sh

RUN  chmod +x /tmp/pyenv_installation.sh \
 && /tmp/pyenv_installation.sh \
 && chmod +x /opt/bin/start_selenium.sh

EXPOSE 4444
