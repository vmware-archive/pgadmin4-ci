FROM selenium/node-chrome:3.4.0-chromium

USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# chrome apt repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# yarn apt repository
RUN wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN sh -c 'echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list'
RUN apt-get update

# copy utility for pyperclip to work in the test
RUN apt-get -y install xsel

# install node
RUN wget -q -O - https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs

# install yarn
RUN apt-get -y install yarn

# Install postgres client library
RUN apt-get -y install libpq-dev

RUN apt-get -y install python python-dev git build-essential bzip2 libreadline6 sqlite3 libsqlite3-dev

RUN apt-get install -y wget
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

COPY pyenv_installation.sh /tmp/pyenv_installation.sh
RUN chmod +x /tmp/pyenv_installation.sh

RUN /tmp/pyenv_installation.sh

COPY start_selenium.sh /opt/bin/start_selenium.sh
RUN chmod +x /opt/bin/start_selenium.sh

EXPOSE 4444