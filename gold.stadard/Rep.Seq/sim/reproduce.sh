. /u/local/Modules/default/init/modules.sh
module load bwa
module load python/2.7
module load samtools
while read line
do
./true.reads/reproduce.sh ${line}
done<./raw.data.bam/samples.txt
