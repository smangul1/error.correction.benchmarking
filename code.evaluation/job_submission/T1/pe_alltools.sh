#!/bin/bash

AUTHOR="keithgmi"

# master list of hashes to upload the master directory 

################### HOST SPECIFIC ################################

BFC="1yJ1EUiPCnKmG0Ird9MWwFnf2phZXGOjp"
BLESS="1mGjdH6c40pSNsgHyS11l-97IIuSr55Au"
CORAL="1SqAf3D7uEU6Q7iooM9FnUcb65VzE30M9"
FIONA="1QRYtTXsmbhzOJ8xxUqqljvFu-ykwNOdD"
LIGHTER="1BpPgnrFGnW9D-q7o8oV6l8jUgODhtuBo"
MUSKET="1hAfrtIAB_02JJaBfF6JwzIPxwqen18HM"
POLLUX="1mKILuICfxvVN6WDBx7csTAJmzChBIiSq"
RACER="1KozKob6azYzv5NtQ86j56ZDE6o-s0KhJ"
RECKONER="1b_fCiwl5JwQcuPK-ce3UkjqETVX18hDI"
SGA="1zswpxOaysvvDD8Qh4UDF85tUhtmoSTOj"
SOAPEC="1lUk2YWFGQ8whvx2svX9XZPU9OcyhuKHI"


MASTERWRAPPER="/u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/./master_wrapper.sh"

################### HOST SPECIFIC ################################

LENGTH=$1
TARRAY=$2

################### DATASET SPECIFIC ################################
KMER=18                   # kmer length
KMER2=3000000             # estimated number of all kmers
GLEN=3000000000           # estimated genome length
RLEN=$LENGTH              # maximum read length
################### DATASET SPECIFIC ################################



if [ $TARRAY -eq 1 ]; then
	COV=1
elif [ $TARRAY -eq 2 ]; then
	COV=2
elif [ $TARRAY -eq 3 ]; then
	COV=4
elif [ $TARRAY -eq 4 ]; then
	COV=8
elif [ $TARRAY -eq 5 ]; then
	COV=16
elif [ TARRAY -eq 6 ]; then
	COV=32
elif [ $TARRAY -eq 7 ]; then
	COV=64
elif [ $TARRAY -eq 8 ]; then
	COV=128
fi


#---------------------------------------------------------------------------------------------------------------------------------------

#FOR RUNNING WGS T1
################### HOST/DATASET SPECIFIC ################################
TRUE1="/u/flashscratch/k/keithgmi/wgs_simulation_igor/true_reads/t1/t1_true_rl_${LENGTH}_cov_${COV}.1.fastq"
RAW1="/u/flashscratch/k/keithgmi/wgs_simulation_igor/datasets/t1/t1_wgsim_rl_${LENGTH}_cov_${COV}.1.fastq" 

TRUE2="/u/flashscratch/k/keithgmi/wgs_simulation_igor/true_reads/t1/t1_true_rl_${LENGTH}_cov_${COV}.2.fastq"
RAW2="/u/flashscratch/k/keithgmi/wgs_simulation_igor/datasets/t1/t1_wgsim_rl_${LENGTH}_cov_${COV}.2.fastq" 

################### HOST/DATASET SPECIFIC ################################

#---------------------------------------------------------------------------------------------------------------------------------------

#FOR RUNNING WGS T3
################### HOST/DATASET SPECIFIC ################################
#TRUE1="/u/flashscratch/k/keithgmi/wgs_simulation_igor/true_reads/t3/t3_true_rl_${LENGTH}_cov_${COV}.1.fastq"
#RAW1="/u/flashscratch/k/keithgmi/wgs_simulation_igor/datasets/t3/t3_wgsim_rl_${LENGTH}_cov_${COV}.1.fastq" 

#TRUE2="/u/flashscratch/k/keithgmi/wgs_simulation_igor/true_reads/t3/t3_true_rl_${LENGTH}_cov_${COV}.2.fastq"
#RAW2="/u/flashscratch/k/keithgmi/wgs_simulation_igor/datasets/t3/t3_wgsim_rl_${LENGTH}_cov_${COV}.2.fastq" 

################### HOST/DATASET SPECIFIC ################################

#---------------------------------------------------------------------------------------------------------------------------------------

#Testing Parameters

################### HOST/DATASET SPECIFIC ################################
#TRUE1="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_true_sim_rl_100_cov_1_1.fastq" # first read file
#RAW1="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_sim_rl_100_cov_1_1.fastq" 

#TRUE2="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_true_sim_rl_100_cov_1_2.fastq" # second read file
#RAW2="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_sim_rl_100_cov_1_2.fastq"
################### HOST/DATASET SPECIFIC ################################


#---------------------------------------------------------------------------------------------------------------------------------------


################### HOST SPECIFIC ################################
#change the location of the .sh wrapper for each tool

 #qsub -cwd -V -N BFC$JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER 
#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.bfc.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $BFC

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.bless.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $BLESS

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.coral.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $CORAL

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.fiona.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $FIONA

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.lighter.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $LIGHTER

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.musket.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $MUSKET

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.pollux.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $POLLUX

#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.racer.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $RACER

$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.reckoner.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $RECKONER

$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.sga.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $SGA

################### HOST SPECIFIC ################################


# TODO ADD THE REST OF THE TOOLS

#qsub -cwd -V -N SOAPEC$JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER 
#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.soapec.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $SOAPEC
#add rcorrector, and others from Brian




