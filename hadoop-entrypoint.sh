#!/bin/bash

startMaster(){
	cd /usr/local/hadoop-2.7.7/sbin
	./start-all.sh
}

main(){
	service sshd restart
	sleep 5

	hdfs namenode -format -force

	if [ ${ROLE} == "master" ]
	then
		startMaster
	fi
}

main