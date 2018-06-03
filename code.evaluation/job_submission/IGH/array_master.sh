#!/bin/bash
HDATA=20G
TIME=140:00:00
JOBNAME=REPSEQIGH

qsub -cwd -V -N ${JOBNAME}_50 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-8 ./qarray.sh 50
qsub -cwd -V -N ${JOBNAME}_75 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-8 ./qarray.sh 75
qsub -cwd -V -N ${JOBNAME}_100 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-8 ./qarray.sh 100
