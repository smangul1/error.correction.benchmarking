. /u/local/Modules/default/init/modules.sh
module load bowtie2
module load python/2.7

while read line
do
./true.reads/reproduce.sh ${line}
done<./raw.data.bam/samples.suffix.txt
