#!/bin/sh

### Start Stucco Components
STUCCO_HOME=/stucco

# Start rt (streaming-processor)
RT_DIR=${STUCCO_HOME}/rt
if [ -d ${RT_DIR} ]; then
  echo 'Starting rt streaming processor...'
  cd ${RT_DIR}/streaming-processor
  mvn clean package
  supervisord -c target/classes/supervisord.conf &
else
  echo 'The rt repository is not available. Do a `git clone https://github.com/stucco/rt.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi

# Start document-service
DS_DIR=${STUCCO_HOME}/document-service
if [ -d ${DS_DIR} ]; then
  echo 'Starting document-service...'
  cd ${DS_DIR}
  forever start --append -l /var/log/doc-service-forever.log -o /var/log/doc-service-out.log -e /var/log/doc-service-err.log --pid /var/run/document-service.pid server.js
else
  echo 'The document-service repository is not available. Do a `git clone https://github.com/stucco/document-service.git` into the main stucco project directory and it will be available in the virtual machine, mounted under /stucco'
fi

echo 'waiting for stucco startup to finish...'
sleep 1m

#TODO is this output still useful?
echo "!!! /stucco/rt/streaming-processor/supervisord.log !!!"
cat /stucco/rt/streaming-processor/supervisord.log