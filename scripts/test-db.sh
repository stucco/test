#!/bin/sh

#install jq
#wget https://stedolan.github.io/jq/download/linux64/jq
#chmod a+x jq
#sudo mv jq /usr/local/bin

#actually, need to build from source, so we have the -e option available.  can change back after version bump.
git clone https://github.com/stedolan/jq.git
cd jq
autoreconf -i
./configure
make -j8
make check
sudo make install
cd ..

#check status for debugging
rabbitmqctl status
rabbitmqctl list_queues
rabbitmqctl list_exchanges

#dump a bunch of logs to console
echo "!!! /var/log/doc-service-forever.log !!!"
cat /var/log/doc-service-forever.log

echo "!!! ls -al /stucco/rt/ !!!"
ls -al /stucco/rt/

echo "!!! /stucco/rt/stucco-rt.log !!!"
cat /stucco/rt/stucco-rt.log

curl 'http://localhost:8182/graphs' > graphs.out
# {"version":"2.4.0","name":"Rexster: A Graph Server","graphs":["graph"],"queryTime":20.218999,"upTime":"0[d]:00[h]:15[m]:11[s]"}
jq '.' graphs.out
if [ $? -ne 0 ]; then
	exit 1
fi
jq -e '.version == "2.4.0"' graphs.out
if [ $? -ne 0 ]; then
	exit 1
fi
jq -e '(.graphs | length == 1) and (.graphs[0] == "graph")' graphs.out
if [ $? -ne 0 ]; then
	exit 1
fi

curl 'localhost:8182/graphs/graph/vertices?key=name&value=CVE-2013-2028' > cve_vertex.out
# {"version":"2.4.0","results":[{"vertexType":"vulnerability","source":"Metasploit","name":"CVE-2013-2028","_id":220,"_type":"vertex"}],"totalSize":1,"queryTime":1.03591}
jq '.' cve_vertex.out
if [ $? -ne 0 ]; then
	exit 1
fi
jq -e '(.results | length == 1) and (.results[0]._type == "vertex")' cve_vertex.out
if [ $? -ne 0 ]; then
	exit 1
fi
jq -e '(.results[0].name == "CVE-2013-2028") and (.results[0].vertexType == "vulnerability")' cve_vertex.out
if [ $? -ne 0 ]; then
	exit 1
fi