#!/bin/bash
HDATA=30G
TIME=300:00:00
JOBNAME=WGS_T3

qsub -cwd -V -N ${JOBNAME}_50 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-6 ./qarray.sh 50
qsub -cwd -V -N ${JOBNAME}_75 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-6 ./qarray.sh 75
qsub -cwd -V -N ${JOBNAME}_100 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-6 ./qarray.sh 100
qsub -cwd -V -N ${JOBNAME}_150 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-6 ./qarray.sh 150




