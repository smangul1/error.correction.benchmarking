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

TARRAY=$2
TSET=$1

################### DATASET SPECIFIC ################################
KMER=18                   # kmer length
KMER2=3000000             # estimated number of all kmers
GLEN=405000               # estimated genome length
RLEN=$LENGTH              # maximum read length
################### DATASET SPECIFIC ################################


#KMER 18
if [ $TARRAY -eq 1 ]; then
	SRA=SRR1543963
	KMER=18
elif [ $TARRAY -eq 2 ]; then
	SRA=SRR1543964
	KMER=18
elif [ $TARRAY -eq 3 ]; then
	SRA=SRR1543965
	KMER=18
elif [ $TARRAY -eq 4 ]; then
	SRA=SRR1543966
	KMER=18
elif [ $TARRAY -eq 5 ]; then
	SRA=SRR1543967
	KMER=18
elif [ $TARRAY -eq 6 ]; then
	SRA=SRR1543968
	KMER=18
elif [ $TARRAY -eq 7 ]; then
	SRA=SRR1543969
	KMER=18
elif [ $TARRAY -eq 8 ]; then
	SRA=SRR1543970
	KMER=18
elif [ $TARRAY -eq 9 ]; then
	SRA=SRR1543971
	KMER=18
elif [ $TARRAY -eq 10 ]; then
	SRA=SRR1543972
	KMER=18
elif [ $TARRAY -eq 11 ]; then
	SRA=SRR1543973
	KMER=18

#KMER 19
elif [ $TARRAY -eq 12 ]; then
	SRA=SRR1543963
	KMER=19
elif [ $TARRAY -eq 13 ]; then
	SRA=SRR1543964
	KMER=19
elif [ $TARRAY -eq 14 ]; then
	SRA=SRR1543965
	KMER=19
elif [ $TARRAY -eq 15 ]; then
	SRA=SRR1543966
	KMER=19
elif [ $TARRAY -eq 16 ]; then
	SRA=SRR1543967
	KMER=19
elif [ $TARRAY -eq 17 ]; then
	SRA=SRR1543968
	KMER=19
elif [ $TARRAY -eq 18 ]; then
	SRA=SRR1543969
	KMER=19
elif [ $TARRAY -eq 19 ]; then
	SRA=SRR1543970
	KMER=19
elif [ $TARRAY -eq 20 ]; then
	SRA=SRR1543971
	KMER=19
elif [ $TARRAY -eq 21 ]; then
	SRA=SRR1543972
	KMER=19
elif [ $TARRAY -eq 22 ]; then
	SRA=SRR1543973
	KMER=19

#KMER 20
elif [ $TARRAY -eq 23 ]; then
	SRA=SRR1543963
	KMER=20
elif [ $TARRAY -eq 24 ]; then
	SRA=SRR1543964
	KMER=20
elif [ $TARRAY -eq 25 ]; then
	SRA=SRR1543965
	KMER=20
elif [ $TARRAY -eq 26 ]; then
	SRA=SRR1543966
	KMER=20
elif [ $TARRAY -eq 27 ]; then
	SRA=SRR1543967
	KMER=20
elif [ $TARRAY -eq 28 ]; then
	SRA=SRR1543968
	KMER=20
elif [ $TARRAY -eq 29 ]; then
	SRA=SRR1543969
	KMER=20
elif [ $TARRAY -eq 30 ]; then
	SRA=SRR1543970
	KMER=20
elif [ $TARRAY -eq 31 ]; then
	SRA=SRR1543971
	KMER=20
elif [ $TARRAY -eq 32 ]; then
	SRA=SRR1543972
	KMER=20
elif [ $TARRAY -eq 33 ]; then
	SRA=SRR1543973
	KMER=20

#KMER 21
elif [ $TARRAY -eq 34 ]; then
	SRA=SRR1543963
	KMER=21
elif [ $TARRAY -eq 35 ]; then
	SRA=SRR1543964
	KMER=21
elif [ $TARRAY -eq 36 ]; then
	SRA=SRR1543965
	KMER=21
elif [ $TARRAY -eq 37 ]; then
	SRA=SRR1543966
	KMER=21
elif [ $TARRAY -eq 38 ]; then
	SRA=SRR1543967
	KMER=21
elif [ $TARRAY -eq 39 ]; then
	SRA=SRR1543968
	KMER=21
elif [ $TARRAY -eq 40 ]; then
	SRA=SRR1543969
	KMER=21
elif [ $TARRAY -eq 41 ]; then
	SRA=SRR1543970
	KMER=21
elif [ $TARRAY -eq 42 ]; then
	SRA=SRR1543971
	KMER=21
elif [ $TARRAY -eq 43 ]; then
	SRA=SRR1543972
	KMER=21
elif [ $TARRAY -eq 44 ]; then
	SRA=SRR1543973
	KMER=21

#KMER 22
elif [ $TARRAY -eq 45 ]; then
	SRA=SRR1543963
	KMER=22
elif [ $TARRAY -eq 46 ]; then
	SRA=SRR1543964
	KMER=22
elif [ $TARRAY -eq 47 ]; then
	SRA=SRR1543965
	KMER=22
elif [ $TARRAY -eq 48 ]; then
	SRA=SRR1543966
	KMER=22
elif [ $TARRAY -eq 49 ]; then
	SRA=SRR1543967
	KMER=22
elif [ $TARRAY -eq 50 ]; then
	SRA=SRR1543968
	KMER=22
elif [ $TARRAY -eq 51 ]; then
	SRA=SRR1543969
	KMER=22
elif [ $TARRAY -eq 52 ]; then
	SRA=SRR1543970
	KMER=22
elif [ $TARRAY -eq 53 ]; then
	SRA=SRR1543971
	KMER=22
elif [ $TARRAY -eq 54 ]; then
	SRA=SRR1543972
	KMER=22
elif [ $TARRAY -eq 55 ]; then
	SRA=SRR1543973
	KMER=22

#KMER 23
elif [ $TARRAY -eq 56 ]; then
	SRA=SRR1543963
	KMER=23
elif [ $TARRAY -eq 57 ]; then
	SRA=SRR1543964
	KMER=23
elif [ $TARRAY -eq 58 ]; then
	SRA=SRR1543965
	KMER=23
elif [ $TARRAY -eq 59 ]; then
	SRA=SRR1543966
	KMER=23
elif [ $TARRAY -eq 60 ]; then
	SRA=SRR1543967
	KMER=23
elif [ $TARRAY -eq 61 ]; then
	SRA=SRR1543968
	KMER=23
elif [ $TARRAY -eq 62 ]; then
	SRA=SRR1543969
	KMER=23
elif [ $TARRAY -eq 63 ]; then
	SRA=SRR1543970
	KMER=23
elif [ $TARRAY -eq 64 ]; then
	SRA=SRR1543971
	KMER=23
elif [ $TARRAY -eq 65 ]; then
	SRA=SRR1543972
	KMER=23
elif [ $TARRAY -eq 66 ]; then
	SRA=SRR1543973
	KMER=23

#KMER 24
elif [ $TARRAY -eq 67 ]; then
	SRA=SRR1543963
	KMER=24
elif [ $TARRAY -eq 68 ]; then
	SRA=SRR1543964
	KMER=24
elif [ $TARRAY -eq 69 ]; then
	SRA=SRR1543965
	KMER=24
elif [ $TARRAY -eq 70 ]; then
	SRA=SRR1543966
	KMER=24
elif [ $TARRAY -eq 71 ]; then
	SRA=SRR1543967
	KMER=24
elif [ $TARRAY -eq 72 ]; then
	SRA=SRR1543968
	KMER=24
elif [ $TARRAY -eq 73 ]; then
	SRA=SRR1543969
	KMER=24
elif [ $TARRAY -eq 74 ]; then
	SRA=SRR1543970
	KMER=24
elif [ $TARRAY -eq 75 ]; then
	SRA=SRR1543971
	KMER=24
elif [ $TARRAY -eq 76 ]; then
	SRA=SRR1543972
	KMER=24
elif [ $TARRAY -eq 77 ]; then
	SRA=SRR1543973
	KMER=24
fi


#---------------------------------------------------------------------------------------------------------------------------------------

#FOR RUNNING REPSEQ SIM IGH
################### HOST/DATASET SPECIFIC ################################
#TRUE1="/u/flashscratch/k/keithgmi/S2_dataset_igor/S2_dataset/true_reads/IGH/sim_rl_${LENGTH}_cov_${COV}/true_1.fastq" # first read file
#RAW1="/u/flashscratch/k/keithgmi/S2_dataset_igor/S2_dataset/datasets/IGH/sim_rl_${LENGTH}_cov_${COV}/rep.seq_sim_rl_${LENGTH}_cov_${COV}_1.fastq" 

#TRUE2="/u/flashscratch/k/keithgmi/S2_dataset_igor/S2_dataset/true_reads/IGH/sim_rl_${LENGTH}_cov_${COV}/true_2.fastq" # second read file
#RAW2="/u/flashscratch/k/keithgmi/S2_dataset_igor/S2_dataset/datasets/IGH/sim_rl_${LENGTH}_cov_${COV}/rep.seq_sim_rl_${LENGTH}_cov_${COV}_2.fastq"
################### HOST/DATASET SPECIFIC ################################

#---------------------------------------------------------------------------------------------------------------------------------------

#FOR RUNNING REPSEQ REAL!! Though this is single end lets just use the paired end wrappers.
################### HOST/DATASET SPECIFIC ################################
TRUE1="/u/flashscratch/k/keithgmi/rep_seq_real/generate_rsr_data/true/${SRA}_true.fastq" # first read file
RAW1="/u/flashscratch/k/keithgmi/rep_seq_real/generate_rsr_data/raw/${SRA}_raw.fastq" 


#These will just point to blank files
TRUE2="/u/flashscratch/k/keithgmi/rep_seq_real/generate_rsr_data/blank.fastq" 
RAW2="/u/flashscratch/k/keithgmi/rep_seq_real/generate_rsr_data/blank.fastq"
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

if [ $TSET -eq 1 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.bfc.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $BFC

elif [ $TSET -eq 2 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.bless.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $BLESS

elif [ $TSET -eq 3 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.coral.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $CORAL

elif [ $TSET -eq 4 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.fiona.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $FIONA

elif [ $TSET -eq 5 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.lighter.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $LIGHTER

elif [ $TSET -eq 6 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.musket.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $MUSKET

elif [ $TSET -eq 7 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.pollux.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $POLLUX

elif [ $TSET -eq 8 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.racer.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $RACER

elif [ $TSET -eq 9 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.reckoner.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $RECKONER

elif [ $TSET -eq 10 ]; then

	$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.sga.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $SGA

fi


################### HOST SPECIFIC ################################


# TODO ADD THE REST OF THE TOOLS

#qsub -cwd -V -N SOAPEC$JOBNAME -l h_data=$HDATA,highp,time=$TIME -M $USER 
#$MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.soapec.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $SOAPEC
#add rcorrector, and others from Brian




