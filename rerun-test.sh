#!/bin/sh

gem install travis -v 1.6.14 --no-rdoc --no-ri

echo y | travis version

travis login --github-token "c528321727cdc581f77554ba6dc3c62e5c63764d" #test robot account

# cancel pending job (if any) and then wait a bit for it to actually stop.
# This is because running jobs cannot be restarted, and canceling/restarting immediately back to back can apparently cause strange behavior.
travis cancel -r stucco/test
sleep 3

travis restart -r stucco/test --debug