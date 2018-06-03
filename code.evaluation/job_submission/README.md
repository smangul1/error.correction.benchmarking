array_master.sh 
SPECIFIC TO DATASET BEING RAN
--specify -t range for 1..8 corresponding to 1,2,4,8,16,32,64,128 coverages
--edit HDATA variable as needed
--edit TIME variable as needed
--an array will run for length 50, 75, and 100 so add more qsub array runs as needed

qarray.sh
--called by the array_master.sh as instructed by this link: https://www.ccn.ucla.edu/wiki/index.php/Hoffman2:Submitting_Jobs#Job_Arrays

pe_alltools.sh
SPECIFIC TO DATASET/HOST BEING RAN (See labels)
--specify the kmer, kmer2, glen
--specify the paths to files and general format:

--called by the qarray.sh with 2 arguments: a 
	-value of -t ($SGE_TASK_ID) specified as the array of the qsub (internal to each qsub array)
	-length specified for each of the qsub arrays (external to each qsub array)

master_wrapper.sh
SPECIFIC TO HOST BEING RAN (See labels)
