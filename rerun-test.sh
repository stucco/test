#!/bin/sh

gem install travis -v 1.6.14 --no-rdoc --no-ri

echo y | travis version

travis login --github-token "c528321727cdc581f77554ba6dc3c62e5c63764d" #test robot account

travis restart -r stucco/test --debug