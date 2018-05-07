FROM python:3

# chrome and yarn apt repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
 && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
 && sh -c 'echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list'

# yarn apt repository
RUN apt-get update

# copy utility for pyperclip to work in the test, other libraries needed by chrome and the tests
# install dbus - chromedriver needs this to talk to google-chrome
RUN apt-get -y install xsel wget xvfb unzip google-chrome-stable dbus dbus-x11 libpq-dev --fix-missing
 && ln -sf /bin/dbus-daemon /usr/bin/dbus-daemon     # /etc/init.d/dbus has the wrong location
 && ln -sf /bin/dbus-uuidgen /usr/bin/dbus-uuidgen   # /etc/init.d/dbus has the wrong location

# install node and yarn
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
 && apt-get -y install nodejs yarn
