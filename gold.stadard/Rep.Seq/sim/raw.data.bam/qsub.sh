. /u/local/Modules/default/init/modules.sh
module load bowtie2
qsub -cwd -V -N create_sam -l h_data=15G,time=24:00:00 reproduce.sh
