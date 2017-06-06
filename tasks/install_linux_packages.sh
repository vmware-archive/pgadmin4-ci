#!/usr/bin/env bash

# copy utility for pyperclip to work in the test
apt-get update
apt-get install xsel

# update google chrome so it works with new chromedriver
#curl -s https://raw.githubusercontent.com/chronogolf/circleci-google-chrome/master/use_chrome_stable_version.sh | bash

curl -L -o google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
dpkg -i google-chrome.deb;
sed -i 's|HERE/chrome\"|HERE/chrome\" --disable-setuid-sandbox|g' /opt/google/chrome/google-chrome;
rm google-chrome.deb