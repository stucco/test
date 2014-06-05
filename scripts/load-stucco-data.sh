#!/bin/sh

STUCCO_HOME=/stucco

echo "Loading data into message queue..."

cd $STUCCO_HOME
$STUCCO_HOME/collectors/replay.sh

#wait for data to actually load.  (Needed to break these up so travis doesn't give up.)
sleep 5m
echo 5m...
sleep 5m
echo 10m...
sleep 5m
echo 15m...
sleep 5m
echo 20m...
sleep 5m
echo 25m...
sleep 5m
echo 30m...