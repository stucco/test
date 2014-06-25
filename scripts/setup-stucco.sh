#!/bin/sh

echo "Installing remaining dependencies..." 

echo y | sudo apt-get install supervisor
sudo easy_install supervisor

echo "Installing Stucco components..."

STUCCO_HOME=/stucco

sudo mkdir -p $STUCCO_HOME
sudo chmod 4777 $STUCCO_HOME
#sudo chown vagrant:vagrant $STUCCO_HOME


### Download the repositories
cd $STUCCO_HOME
repos="ontology config-loader rt collectors document-service get-exogenous-data"
for repo in $repos; do
  IFS=" "
  echo "cloning ${repo}"
  git clone --recursive https://github.com/stucco/${repo}.git
done

# update conf file for exogenous data
cp /home/travis/build/stucco/test/sites.yml $STUCCO_HOME/get-exogenous-data/sites.yml 
# Download exogenous data and put in data dir
cd $STUCCO_HOME/get-exogenous-data
npm start

#Move the NVD test data in with the rest of the exogenous data
cp /home/travis/build/stucco/test/nvdcve-test.xml $STUCCO_HOME/get-exogenous-data/data/nvdcve-2.0-2013.xml 

# Move endogenous data into data dir
#cd $STUCCO_HOME/endogenous-data-uc1

# Load configuration into etcd
cd $STUCCO_HOME/config-loader
NODE_ENV=vagrant node load.js

# Compile rt
cd $STUCCO_HOME/rt
./maven-rt-build.sh
cd streaming-processor
mvn clean package

# Install node modules and start document-service
cd $STUCCO_HOME/document-service
npm install --quiet

# Install collectors
cd $STUCCO_HOME/collectors
./maven-collectors-build.sh

#set various permissions
sudo gpasswd -a logstash vagrant
sudo chmod g+w /stucco/rt/
sudo chmod g+w /stucco/rt/streaming-processor
sudo chown -R vagrant:vagrant $STUCCO_HOME

echo "Stucco has been installed."
