
AUTHOR="keithgmi"

# master list of hashes to upload the master directory 



#########################################################################
######  General Master Wrapper Script For EC Benchmarking Pipeline  #####
#########################################################################

#Steps of the script
# 1) perform the error correction for wrapper with true, raw, kmer args
# 2) run ec evaluation to produce the compressed files and upload EC reads
# 3) get rid of the ec reads from STEP 1 on the cluster
# 4) produces a summary from the compressed files for the relevant reads
# 5) upload the compressed files and summary files to GDRIVE
# 6) get rid of the compressed and summary files from the cluster


true=$1
raw=$2
wrapper=$3 
kmer=$4
kmer2=$5
glength=$6
rlen=$7
true2=$8
raw2=$9
gdirvehash=$10

## Testing Parameters
# true="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_true_sim_rl_100_cov_1_1.fastq"
# raw="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_sim_rl_100_cov_1_1.fastq"
# wrapper="/u/home/k/keithgmi/project-zarlab/ec2/wrappers/paired_end/run.musket.sh"
# kmer=18
# kmer2=300000
# glength=3000
# rlen=100
# true2="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_true_sim_rl_100_cov_1_2.fastq"
# raw2="/u/flashscratch/k/keithgmi/testing_repseq_sim/rep.seq_test_sim_rl_100_cov_1_2.fastq"
# gdrivehash=1hAfrtIAB_02JJaBfF6JwzIPxwqen18HM

#these will act as the temp. directories
outdir="/u/flashscratch/k/keithgmi/master_wrapper_ec/"
outdircompressed="/u/flashscratch/k/keithgmi/master_wrapper_compressed/"
outsummary="/u/flashscratch/k/keithgmi/ec_summary/"

raw2filename=${raw2##*/}
rawfilename=${raw##*/}
wrappername=${wrapper##*/}
raw2cleaned=${raw2filename%.fastq}
rawcleaned=${rawfilename%.fastq}

echo "Raw2 Name: $raw2cleaned"
echo "Raw Name: $rawcleaned"
echo "Wrapper Name: $wrappername"


echo "----------------------------------------------------------------------------------"
echo "PART 1: Run Tool Wrapper"
echo "----------------------------------------------------------------------------------"

# 1.A) find the proper settings to run the wrapper with 

if [[ $wrapper != *".se."* ]]; then
	if [[ $wrapper == *"bfc"* ]]; then
		# run bfc
		tool=bfc
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer $glength

	elif [[ $wrapper == *"bless"* ]]; then
		# run bless
		tool=bless
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer

	elif [[ $wrapper == *"coral"* ]]; then
		# run coral
		tool=coral
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer

	elif [[ $wrapper == *"fiona"* ]]; then
		# run fiona
		tool=fiona
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $glength

	elif [[ $wrapper == *"lighter"* ]]; then
		# run lighter
		tool=lighter
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer $kmer2

	elif [[ $wrapper == *"musket"* ]]; then	
		# run musket
		tool=musket
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer $kmer2

	elif [[ $wrapper == *"pollux"* ]]; then	
		# run pollux
		tool=pollux
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer

	elif [[ $wrapper == *"racer"* ]]; then
		# run racer
		tool=racer
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $glength

	elif [[ $wrapper == *"reckoner"* ]]; then
		# run reckoner
		tool=reckoner
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer $glength

	elif [[ $wrapper == *"sga"* ]]; then
		# run sga
		tool=sga
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer

	elif [[ $wrapper == *"soapec"* ]]; then
		# run soapec
		tool=soapec
		echo "Running $tool for Paired End Data"
		$wrapper $raw $raw2 $outdir $kmer $rlen
	fi
fi


# 1.B) retrieve the proper ec file from the directory and the log... what to do with the log file????????????????????????????????????????
for filename in $outdir*;
do
	if [[ "$filename" == *"$rawcleaned"* ]] || [[ "$filename" == *"$raw2cleaned"* ]]; then
		if [[ "$filename" != *".log"* ]] && [[ "$filename" == *"$tool"* ]]; then
			ecfound=true
			echo "Found the EC $filename in $outdir"
			ec=$filename
		elif [[ "$filename" == *".log"* ]] && [[ "$filename" == *"$tool"* ]]; then
			echo "Found the EC LOG $filename in $outdir"
			eclog=$filename
		fi
	fi
done

echo "Error corrected file found?: $ecfound"

# 1.C) unzip the ec file produced
gunzip $ec

unzippedec=${ec%.gz}

echo "----------------------------------------------------------------------------------"
echo "PART 2: Run EC Evaluation"
echo "----------------------------------------------------------------------------------"


. /u/local/Modules/default/init/modules.sh
module load python

# for single end
if [[ $wrapper == *".se."* ]]; then
	echo "Beginning evaluation for a single end set."
	python /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/code.evaluation/ec_evaluation.py -base_dir "$outdircompressed" -true_1 "$true" -raw_1 "$raw" -ec_1 "$unzippedec"
	echo "Finished evaluation for a single end set."

# for paired end
else
	echo "Beginning evaluation for a paired end set."
	python /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/code.evaluation/ec_evaluation.py -base_dir "$outdircompressed" -true_1 "$true" -true_2 "$true2" -raw_1 "$raw" -raw_2 "$raw2" -ec_1 "$unzippedec"
	echo "Finished evaluation for a paired end set."
fi


## NOT planning on uploading the EC files
# # should we specify something 
# ecgdrive=1PWqI5IqUfCtKog4HodJYIqusjZtLAzSY
# echo "Uploading the file $newec to google drive."
# /u/home/k/keithgmi/code/./gdrive-linux-x64 upload --parent $ecgdrive $newec



echo "----------------------------------------------------------------------------------"
echo "PART 3: Remove the EC reads produced in PART 1."
echo "----------------------------------------------------------------------------------"

rm $unzippedec
rm $eclog
echo "Removed: $unzippedec, $eclog"


echo "----------------------------------------------------------------------------------"
echo "PART 4: produce summary after finding the proper files"
echo "----------------------------------------------------------------------------------"


for filename in $outdircompressed*; 
do
	if [[ $filename == *"$rawcleaned"* ]] || [[ $filename == *"$raw2cleaned"* ]]; then
		if [[ $filename == *"base_data"* ]] && [[ $filename == *"$tool"* ]]; then
			basefile=$filename
			echo "Successfully found basefile: $outdircompressed$filename";
		elif [[ $filename == *"read_data"* ]] && [[ $filename == *"$tool"* ]]; then
			readfile=$filename
			echo "Successfully found read file: $outdircompressed$filename";
		fi
	fi
	# upload to gdrive in the directory for the relative tool then remove
	
done

# run python script here to produce the summary.
python /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/code.evaluation/ec_summary.py -kmer $kmer -wrapper $wrapper -read_data $readfile -base_data $basefile -ec_name $ec -outdir $outsummary



echo "----------------------------------------------------------------------------------"
echo "PART 5: upload compressed files, then remove compressed files"
echo "----------------------------------------------------------------------------------"

for filename in $outdircompressed*;
do
	if [[ $filename == *"$rawcleaned"* ]] || [[ $filename == *"$raw2cleaned"* ]]; then
		if [[ $filename == *"$tool"* ]]; then
			/u/home/k/keithgmi/code/./gdrive-linux-x64 upload --parent $gdrivehash $filename
			rm $filename
		fi
	fi
done	