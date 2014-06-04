#!/bin/sh

STUCCO_HOME=/stucco

echo "Setting configuration for integration tests..."

pwd

ls

cp stucco.yml $STUCCO_HOME/config-loader/config/stucco.yml 

cd $STUCCO_HOME/config-loader

node clear.js
node load.js