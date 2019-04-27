# Final Error Correction Benchmarking Repository

## Description of project directories
- `code.evaluation`:
    - `data_analysis`:
        - `data`: contains the final, compressed data used for analysis. 
        - `IGH_Analysis.ipynb`, `RSR_Analysis.ipynb`, `T1_Analysis.ipynb`: Jupyter nobebooks used to generate figures and analysis of the final compressed data generated from `/code.evaluation/evaluation/ec_summary.py` which was called after each tool was ran in the `code.evaluation/job_submission/master_wrapper.sh` 
    - `job_submission`: contains information on how to submit jobs for all/sets of the tools on the hoffman cluster for each of the datasets evaluated in this study. 
        - see `README.md` in this directory. 
    - `evaluation`: 
        - `../job_submission/master_wrapper.sh` calls `ec_evaluation.py` which calls `ec_data_compression.py` 
        - `../job_submission/master_wrapper.sh` then calls `ec_summary.py` with the files created in `ec_data_compression.py`
        - `data_metrics.py` generates metrics such as precision, gain, accuracy, and sensitivity from the summary data.
    - `testing_data`:
        - shows an example of small file set to be ran
        - displays examples of compressed file output from evaluation. 
    - `wrappers`:
        - `.sh` wrappers used to run all tools, produce standard log files.
        - contains the wrappers for the tools used. 
        - wrappers convert the reads to a merged input file.
        - single end reads are ok for paired end wrappers by passing ```blank.fastq```.
 
- `gold.standard`:
    - `rep_seq_real`: 
        - contains the scripts for submitting the jobs to create the UMI based gold standard reads for the TCR data. (`generate_files.sh`, `rep_seq_real_to_true.py`)
        - contains the scripts for visualizing the UMI grouping sizes. (`rep_seq_visualizer.py`)
        - contains the scripts for retrieving SRA data using qsubs on the hoffman cluster (`handle_dump.sh`)
- `true.reads`:
   

