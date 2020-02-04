#!/bin/bash

#fofn-checker


for TAXA in $(cat $1); do

	# generate random prefix for all tmp files
	RAND_1=`echo $((1 + RANDOM % 100))`
	RAND_2=`echo $((100 + RANDOM % 200))`
	RAND_3=`echo $((200 + RANDOM % 300))`
	RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

	/home/tseemann/tasks/tim.stinear/mock_soil_ARC_2018/mockery.pl --seed 42 --genes 10010 --num 100 --numpos 20 --core 0.001 --noise 0.${TAXA} --spike 20 > ${RAND}.txt

	# make target
	cut -f 1 ${RAND}.csv | tr '\t' ',' > target_n-100_npos-20_n-spike-20_n-genes-10010_n-core-10000_n-non-core-10000000_noise_0.${TAXA}.csv

	# make features
	cut -f 2- ${RAND}.csv | tr '\t' ',' > data_n-100_npos-20_n-spike-20_n-genes-10010_n-core-10000_n-non-core-10000000_noise_0.${TAXA}.csv
	
	# transpose features
	tr ',' '\t' < data_n-100_npos-20_n-spike-20_n-genes-10010_n-core-10000_n-non-core-10000000_noise_0.${TAXA}.csv | datamash transpose -H | tr '\t' ',' > data_n-100_npos-20_n-spike-20_n-genes-10010_n-core-10000_n-non-core-10000000_noise_0.${TAXA}.tr.csv	

	
done

		