. /u/local/Modules/default/init/modules.sh
module load python

#
# SAVE FOR LATER: How to run example on cluster.
python rep_seq_real_to_true.py -input_dir $PWD/ex_input_dir/  -output_dir /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/gold.stadard/Rep.Seq/real/ex_output_dir/
#
# THIS IS FOR REAL
#python rep_seq_real_to_true.py "$TRUE_DIR" "$RAW_DIR"

