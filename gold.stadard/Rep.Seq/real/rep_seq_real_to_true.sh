#!/usr/bin/pytho
# be sure to have activate relevant ec3 conda then run this qsub
# chmod u+x submit_qiime2.sh


# testing environment
# TRUE_DIR="/media/sf_EC3/gold.stadard/Rep.Seq/real/true"
# RAW_DIR="/media/sf_EC3/gold.stadard/Rep.Seq/real/data"

#hoffman environment
TRUE_DIR = "/u/flashscratch/k/keithgmi/rep_seq_real_true"
RAW_DIR = "/u/home/s/serghei/project/EC_survey/RepSeq_real/"

echo $TRUE_DIR
echo $RAW_DIR

chmod +x rep_seq_real_to_true.py
python rep_seq_real_to_true.py "$TRUE_DIR" "$RAW_DIR"
