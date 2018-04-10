#!/bin/bash

sample = $1
#create sam files
echo Starting alignment
bwa mem reference/trans.IGH.fa raw.data/IGH${1}_R1.fastq raw.data/IGH${1}_R2.fastq > IGH${1}.sam
bwa mem reference/trans.TCRA.fa raw.data/TCRA${1}_R1.fastq raw.data/TCRA${1}_R2.fastq > TCRA${1}.sam
echo Done creating sam files
samtools view -S IGH${1}.sam > IGH${1}.temp.sam
samtools view -S TCRA${1}.sam > TCRA${1}.temp.sam

echo add /1 and /2 back to paired reads
python ../code/add_paired_end_tags.py IGH${1}.temp.sam
python ../code/add_paired_end_tags.py TCRA${1}.temp.sam

cat ./raw.data.bam/IGH${1}_R1.fastq ./raw.data.bam/IGH${1}_R2.fastq > IGH${1}.fastq
cat ./raw.data.bam/TCRA${1}_R1.fastq ./raw.data.bam/TCRA${1}_R2.fastq > TCRA${1}.fastq
echo Done Merging files

#create true reads
echo Creating True read
python2.7 ../code/ground_truth.py ./reference/trans.IGH.fa IGH${1}.temp.sam IGH${1}.fastq > IGH${1}.true.fastq
python2.7 ../code/ground_truth.py ./reference/trans.TCRA.fa TCRA${1}.temp.sam TCRA${1}.fastq > TCRA${1}.true.fastq

# move and delete files
rm *temp.sam
mv *true.fastq ./true.reads/
mv *sam raw.data.bam
rm IGH*
rm TCRA*

echo Done
