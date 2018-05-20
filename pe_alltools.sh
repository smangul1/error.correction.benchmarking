#!/bin/bash

AUTHOR="keithgmi"
#Adapted from Igor Mandric script run.all_wrappers.sh

# master list of hashes to upload the master directory 

BFC=1yJ1EUiPCnKmG0Ird9MWwFnf2phZXGOjp
BLESS=1mGjdH6c40pSNsgHyS11l-97IIuSr55Au
CORAL=1SqAf3D7uEU6Q7iooM9FnUcb65VzE30M9
FIONA=1QRYtTXsmbhzOJ8xxUqqljvFu-ykwNOdD
LIGHTER=1BpPgnrFGnW9D-q7o8oV6l8jUgODhtuBo
MUSKET=1hAfrtIAB_02JJaBfF6JwzIPxwqen18HM
POLLUX=1mKILuICfxvVN6WDBx7csTAJmzChBIiSq
RACER=1KozKob6azYzv5NtQ86j56ZDE6o-s0KhJ
RECKONER=1b_fCiwl5JwQcuPK-ce3UkjqETVX18hDI
SGA=1zswpxOaysvvDD8Qh4UDF85tUhtmoSTOj
SOAPEC=1lUk2YWFGQ8whvx2svX9XZPU9OcyhuKHI

# User should change the parameters to run all tools for
# Qsub will be called for each of the tools specifying the master_wrapper

#######################################################################################################################################

MASTERWRAPPER="/u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/./master_wrapper.sh"

JOBNAME="_WGS_100_cov_1_1"

TRUE1="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_true_sim_rl_100_cov_1_1.fastq" # first read file
RAW1="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_sim_rl_100_cov_1_1.fastq" 

TRUE2="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_true_sim_rl_100_cov_1_2.fastq" # second read file
RAW2="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_sim_rl_100_cov_1_2.fastq"

KMER=18                   # kmer length
KMER2=3000000             # estimated number of all kmers
GLEN=3000                 # estimated genome length
RLEN=100                  # maximum read length

#######################################################################################################################################



 qsub -cwd -V -N BFC$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.bfc.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $BFC
 qsub -cwd -V -N BLESS$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.bless.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $BLESS
 qsub -cwd -V -N CORAL$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.coral.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $CORAL
 qsub -cwd -V -N FIONA$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.fiona.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $FIONA
 qsub -cwd -V -N LIGHTER$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.lighter.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $LIGHTER
 qsub -cwd -V -N MUSKET$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.musket.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $MUSKET
 qsub -cwd -V -N POLLUX$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.pollux.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $POLLUX
 qsub -cwd -V -N RACER$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.racer.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $RACER
 qsub -cwd -V -N RECKONER$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.reckoner.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $RECKONER
 qsub -cwd -V -N SGA$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.sga.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $SGA
 qsub -cwd -V -N SOAPEC$JOBNAME -l h_data=24G,highp,time=12:00:00 -M $USER $MASTERWRAPPER $TRUE1 $RAW1 "/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.soapec.sh" $KMER $KMER2 $GLEN $RLEN $TRUE2 $RAW2 $SOAPEC
 #add rcorrector

