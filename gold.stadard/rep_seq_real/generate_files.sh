#!/bin/bash
. /u/local/Modules/default/init/modules.sh
module load python 
python /u/flashscratch/k/keithgmi/rep_seq_real/handle_rep_seq_dump.py -input_file $1 -output_dir /u/flashscratch/k/keithgmi/rep_seq_real/generate_rsr_data

