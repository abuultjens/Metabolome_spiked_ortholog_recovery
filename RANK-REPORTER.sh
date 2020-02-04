#!/bin/bash

# USAGE:
# $ sh RANK-REPORTER.sh [0.00 or 0.20]


rm tmp_TMP_tmp.txt
rm tmp2_TMP_tmp.txt

for TAXA in $(cat SPIKE_LIST.txt); do

	LINE=`grep -n "${TAXA}" ${1}_feat_importances.csv | cut -f 1 -d ':'`
	
	echo "${TAXA}	${LINE}" >> tmp_TMP_tmp.txt
	
done

sort -k2 -n tmp_TMP_tmp.txt > tmp2_TMP_tmp.txt

echo "#------------------------------"
echo "Predictor:        Rank:" 

cat tmp2_TMP_tmp.txt

A=`cat tmp2_TMP_tmp.txt | head -5 | tail -1 | cut -f 2`
B=`cat tmp2_TMP_tmp.txt | head -10 | tail -1 | cut -f 2`
C=`cat tmp2_TMP_tmp.txt | head -15 | tail -1 | cut -f 2`
D=`cat tmp2_TMP_tmp.txt | head -20 | tail -1 | cut -f 2`

echo "#------------------------------"
echo "25%: ${A}"
echo "#------------------------------"
echo "50%: ${B}"
echo "#------------------------------"
echo "75%: ${C}"
echo "#------------------------------"
echo "100%: ${D}"
echo "#------------------------------"


rm tmp_TMP_tmp.txt
rm tmp2_TMP_tmp.txt
