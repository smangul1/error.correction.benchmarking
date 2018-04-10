ls *_R1.fastq | awk -F "_R1.fastq" '{print $1}' >samples.txt
sed -i 's/IGH//g' samples.txt 
sed -i 's/TCRA//g' samples.txt 

#while read line
#do
#bowtie2 --quiet --no-hd --reorder -k 10 -q -p 10 -x ../reference/trans.IGH -1 ${line}_R1.fastq -2 ${line}_R2.fastq -S ${line}.sam
#done<samples.txt
