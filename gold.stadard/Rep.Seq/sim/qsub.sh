qsub -cwd -V -N create_true -l h_data=34G,time=24:00:00,highp -M eplau -m bea reproduce.sh
