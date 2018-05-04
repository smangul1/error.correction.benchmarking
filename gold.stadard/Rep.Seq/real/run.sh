. /u/local/Modules/default/init/modules.sh
module load python

# testing environment
#TRUE_DIR="/media/sf_EC3/gold.stadard/Rep.Seq/real/true"
#RAW_DIR="/media/sf_EC3/gold.stadard/Rep.Seq/real/data"
#
# hoffman environment
#TRUE_DIR = "/u/flashscratch/k/keithgmi/rep_seq_real_true"
#RAW_DIR = "/u/home/s/serghei/project/EC_survey/RepSeq_real"
#
# SAVE FOR LATER: How to run example on cluster.
python rep_seq_real_to_true.py -input_dir $PWD/example/  -output_dir /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/gold.stadard/Rep.Seq/real/example/
#
# THIS IS FOR REAL
#python rep_seq_real_to_true.py "$TRUE_DIR" "$RAW_DIR"
