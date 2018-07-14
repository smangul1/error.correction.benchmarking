#!/bin/bash
HDATA=20G
TIME=140:00:00
JOBNAME=RSR_all_kmers

qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 1
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 2
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 3
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 4
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 5
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 6
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 7
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 8
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 9
qsub -cwd -V -N $JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER -t 1-56 ./qarray.sh 10
:

