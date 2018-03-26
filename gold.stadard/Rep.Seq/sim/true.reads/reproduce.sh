#!/bin/bash

sample = $1

#create sam files
echo Starting alignment
bowtie2 --quiet --no-hd --reorder -k 10 -q -p 10 -x ./reference/trans.IGH -1 ./raw.data.bam/IGH${1}_R1.fastq -2 ./raw.data.bam/IGH${1}_R2.fastq -S IGH${1}.sam

bowtie2 --quiet --no-hd --reorder -k 10 -q -p 10 -x ./reference/trans.TCRA -1 ./raw.data.bam/TCRA${1}_R1.fastq -2 ./raw.data.bam/TCRA${1}_R2.fastq -S TCRA${1}.sam

echo Done creating sam files

#merge  fastq
cat ./raw.data.bam/IGH${1}_R1.fastq ./raw.data.bam/IGH${1}_R2.fastq > IGH${1}.fastq
cat ./raw.data.bam/TCRA${1}_R1.fastq ./raw.data.bam/TCRA${1}_R2.fastq > TCRA${1}.fastq
echo Done Merging files

#create true reads
echo Creating True read
python2.7 ../code/ground_truth.py ./reference/trans.IGH.fa IGH${1}.sam IGH${1}.fastq > IGH${1}.true.fastq
python2.7 ../code/ground_truth.py ./reference/trans.TCRA.fa TCRA${1}.sam TCRA${1}.fastq > TCRA${1}.true.fastq

# move and delete files
mv *true.fastq ./true.reads/
rm IGH*
rm TCRA*
Done
