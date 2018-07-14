#!/bin/bash
HDATA=30G
TIME=300:00:00
JOBNAME=WGS_T1

qsub -cwd -V -N ${JOBNAME}_50_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 1
qsub -cwd -V -N ${JOBNAME}_75_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 1
qsub -cwd -V -N ${JOBNAME}_100_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 1
qsub -cwd -V -N ${JOBNAME}_150_ts_1 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 1


qsub -cwd -V -N ${JOBNAME}_50_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 2
qsub -cwd -V -N ${JOBNAME}_75_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 2
qsub -cwd -V -N ${JOBNAME}_100_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 2
qsub -cwd -V -N ${JOBNAME}_150_ts_2 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 2


qsub -cwd -V -N ${JOBNAME}_50_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 3
qsub -cwd -V -N ${JOBNAME}_75_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 3
qsub -cwd -V -N ${JOBNAME}_100_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 3
qsub -cwd -V -N ${JOBNAME}_150_ts_3 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 3


qsub -cwd -V -N ${JOBNAME}_50_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 4
qsub -cwd -V -N ${JOBNAME}_75_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 4
qsub -cwd -V -N ${JOBNAME}_100_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 4
qsub -cwd -V -N ${JOBNAME}_150_ts_4 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 4


qsub -cwd -V -N ${JOBNAME}_50_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 5
qsub -cwd -V -N ${JOBNAME}_75_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 5
qsub -cwd -V -N ${JOBNAME}_100_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 5
qsub -cwd -V -N ${JOBNAME}_150_ts_5 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 5

qsub -cwd -V -N ${JOBNAME}_50_ts_6 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 6
qsub -cwd -V -N ${JOBNAME}_75_ts_6 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 6
qsub -cwd -V -N ${JOBNAME}_100_ts_6 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 6
qsub -cwd -V -N ${JOBNAME}_150_ts_6 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 6


qsub -cwd -V -N ${JOBNAME}_50_ts_7 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 7
qsub -cwd -V -N ${JOBNAME}_75_ts_7 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 7
qsub -cwd -V -N ${JOBNAME}_100_ts_7 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 7
qsub -cwd -V -N ${JOBNAME}_150_ts_7 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 7


qsub -cwd -V -N ${JOBNAME}_50_ts_8 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 8
qsub -cwd -V -N ${JOBNAME}_75_ts_8 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 8
qsub -cwd -V -N ${JOBNAME}_100_ts_8 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 8
qsub -cwd -V -N ${JOBNAME}_150_ts_8 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 8


qsub -cwd -V -N ${JOBNAME}_50_ts_9 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 9
qsub -cwd -V -N ${JOBNAME}_75_ts_9 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 9
qsub -cwd -V -N ${JOBNAME}_100_ts_9 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 9
qsub -cwd -V -N ${JOBNAME}_150_ts_9 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 9


qsub -cwd -V -N ${JOBNAME}_50_ts_10 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 50 10
qsub -cwd -V -N ${JOBNAME}_75_ts_10 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 75 10
qsub -cwd -V -N ${JOBNAME}_100_ts_10 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 100 10
qsub -cwd -V -N ${JOBNAME}_150_ts_10 -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-42 ./qarray.sh 150 10



