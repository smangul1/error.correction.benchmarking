#!/bin/bash
HDATA=20G
TIME=140:00:00
JOBNAME=REPSEQIGH_all_kmers_check

qsub -cwd -V -N ${JOBNAME}_50_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 50 1
qsub -cwd -V -N ${JOBNAME}_75_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 75 1
qsub -cwd -V -N ${JOBNAME}_100_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 100 1

qsub -cwd -V -N ${JOBNAME}_50_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 50 2
qsub -cwd -V -N ${JOBNAME}_75_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 75 2
qsub -cwd -V -N ${JOBNAME}_100_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 100 2

qsub -cwd -V -N ${JOBNAME}_50_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 50 3
qsub -cwd -V -N ${JOBNAME}_75_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 75 3
qsub -cwd -V -N ${JOBNAME}_100_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 100 3

qsub -cwd -V -N ${JOBNAME}_50_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 50 4
qsub -cwd -V -N ${JOBNAME}_75_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 75 4
qsub -cwd -V -N ${JOBNAME}_100_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 100 4

qsub -cwd -V -N ${JOBNAME}_50_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 50 5
qsub -cwd -V -N ${JOBNAME}_75_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 75 5
qsub -cwd -V -N ${JOBNAME}_100_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 7-56 ./qarray.sh 100 5

