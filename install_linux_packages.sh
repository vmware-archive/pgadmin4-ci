#!/usr/bin/env bash

# copy utility for pyperclip to work in the test
sudo apt-get install xsel

# update google chrome so it works with new chromedriver
curl -s https://raw.githubusercontent.com/chronogolf/circleci-google-chrome/master/use_chrome_stable_version.sh | bash