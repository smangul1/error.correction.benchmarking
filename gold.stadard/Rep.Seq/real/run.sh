. /u/local/Modules/default/init/modules.sh
module load python

# testing environment
#TRUE_DIR="/media/sf_EC3/gold.stadard/Rep.Seq/real/true"
#RAW_DIR="/media/sf_EC3/gold.stadard/Rep.Seq/real/data"
#
# hoffman environment
TRUE_DIR = "/u/flashscratch/k/keithgmi/rep_seq_real_true/"
RAW_DIR = "/u/home/s/serghei/project/EC_survey/RepSeq_real/"
#

# THIS IS FOR REAL
python rep_seq_real_to_true.py "$TRUE_DIR" "$RAW_DIR"