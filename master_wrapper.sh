AUTHOR="keithgmi"


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
glength=$5
true2=$6
raw2=$7

#these will act as the temp. directories
outdir="/u/flashscratch/k/keithgmi/master_wrapper_ec"
outdircompressed="/u/flashscratch/k/keithgmi/master_wrapper_compressed"

raw2filename=${raw2##*/}
rawfilename=${raw##*/}

##########################################################################################
# 1) Run tools rapper-> e.c. reads (some tools also ask to specify the genome length...)
##########################################################################################


# 1.A) then check if it is a tool that takes single end or paired end data
# maybe add a check here to make sure the user did not pass true2 or raw2

if [[ $wrapper == *".se."* ]]; then
	singleend=true
else
	singleend=false
fi

echo "Single End Data Set?: $singleend"

# 1.B) then check if it is a tool that takes the genome length
# double check tools I need to finish here.. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#list that take glength [bfc, lighter]
if [[ $wrapper == *"lighter"* ]] || [[ $wrapper == *"bfc"* ]]; then
	type=1

#list that takes glength but not kmer [fiona, racer ]
elif [[ $wrapper == *"fiona"* ]] || [[ $wrapper == *"racer"* ]]; then
	type=2

#by default the rest take kmer but not glength
else
	type=3
fi

echo "The tool is type: $type"


# 1.C) check 1.A and 1.B to determine how to run the wrapper

if [[ "$singleend" == true ]] && [[ $type == 1 ]]; then
	echo $wrapper $raw $outdir $kmer $glength
elif [[ "$singleend" == true ]] && [[ $type == 2 ]]; then
	echo $wrapper $raw $outdir $glength
elif [[ "$singleend" == true ]] && [[ $type == 3 ]]; then
	echo $wrapper $raw $outdir $kmer
elif [[ "$singleend" == false ]] && [[ $type == 1 ]]; then
	echo $wrapper $raw $raw2 $outdir $kmer $glength;
elif [[ "$singleend" == false ]] && [[ $type == 2 ]]; then
	echo $wrapper $raw $raw2 $outdir $glength
elif [[ "$singleend" == false ]] && [[ $type == 3 ]]; then
	echo $wrapper $raw $raw2 $outdir $kmer
else
	echo "Did not correspond with scenario.. "
fi


# 1.D) retrieve the files from the directory

# i think most tools produce one ec file for the paired end data... ???????????????????????????????????????????
for filename in "$outdir";
do
	if [[ "$filename" == *"$rawfilename"* ]] || [[ "$filename" == *"$raw2filename"* ]]; then
		ecfound=true
		ec=$outdir$filename
	fi
done

echo "Error corrected file found?: $ecfound"


#########################################################################################
# 2) run ec evaluation to produce the compressed files and upload ec reads to gdrive
#########################################################################################
echo "PART 2: Run EC Evaluation"

. /u/local/Modules/default/init/modules.sh
module load python

# for single end
if [[ $wrapper == *".se."* ]]; then
	echo "Beginning evaluation for a single end set."
	python /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/code.evaluation/ec_evaluation.py -base_dir "$outdircompressed" -true_1 "$true" -raw_1 "$raw" -ec_1 "$ec"
	echo "Finished evaluation for a single end set."

# for paired end
else
	echo "Beginning evaluation for a paired end set."
	python /u/home/k/keithgmi/project-zarlab/error.correction.benchmarking/code.evaluation/ec_evaluation.py -base_dir "$outdircompressed" -true_1 "$true" -true_2 "$true2" -raw_1 "$raw" -raw_2 "$raw2" -ec_1 "$ec"
	echo "Finished evaluation for a paired end set."
fi

# should we specify something 
ecgdrive=1PWqI5IqUfCtKog4HodJYIqusjZtLAzSY
gdrive upload --parent $ecgdrive $ec

#########################################################################################
# 3) get rid of the ec reads from STEP 1 on the cluster (upload to gdrive first???)
#########################################################################################
echo "PART 3: Remove the EC reads produced in PART 1."

rm $ec

##########################################################################################
# 4) produces a summary from the compressed files for the relevant reads
##########################################################################################
echo "PART 4: produce summary from the compressed files"

for filename in $outdircompressed 
do
	if [ $filename = *"$rawfilename"*] || [ $filename = *"$raw2filename"*]; then
		if [ $filename = *"base_data"*]; then
			basefile="$outdircompressed/$filename"
			echo "Successfully found basefile: $outdircompressed/$filename";
		elif [ $filename = *"read_data"*]; then
			readfile="$outdircompressed/$filename"
			echo "Successfully found read file: $outdircompressed/$filename";
		fi
	fi
done

# run python script here to produce the summary.
python compression_summary.py -kmer $kmer -wrapper $wrapper -read_data $readfile -base_data $basefile -ec_name $ec


##########################################################################################
# 5) upload the compressed files to GDRIVE, update summary file
##########################################################################################

# should we seperate based on the base_data data_compression etc?????????????????????????????????????????????????
compressedgdrive=14ctrYlB5ldzwcYXG3MaoCmpqLK7SkIPZ
for filename in $outdircompressed 
do
	gdrive upload --parent $compressedgdrive $filenmae
done

# i changed this just to update the summary file on flashscratch since we have to actively make changes to it.
# this will be the data for analysis of all tools and will only append one row for each of the tools ran..



##########################################################################################
# 6) get rid of the compressed and summary files from the cluster
##########################################################################################

rm $outdircompressed/*
