FROM python:3

# chrome apt repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# yarn apt repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN sh -c 'echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list'
RUN apt-get update

# copy utility for pyperclip to work in the test
RUN apt-get -y install xsel

RUN apt-get -y install wget --fix-missing
RUN apt-get -y install xvfb --fix-missing # chrome will use this to run headlessly
RUN apt-get -y install unzip --fix-missing

RUN apt-get -y install google-chrome-stable

# install dbus - chromedriver needs this to talk to google-chrome
RUN apt-get -y install dbus --fix-missing
RUN apt-get -y install dbus-x11 --fix-missing
RUN ln -sf /bin/dbus-daemon /usr/bin/dbus-daemon     # /etc/init.d/dbus has the wrong location
RUN ln -sf /bin/dbus-uuidgen /usr/bin/dbus-uuidgen   # /etc/init.d/dbus has the wrong location

# install chrome
#RUN apt-get -y install google-chrome-stable

# install node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs

# install yarn
RUN apt-get -y install yarn

# Install postgres client library
RUN apt-get -y install libpq-dev
