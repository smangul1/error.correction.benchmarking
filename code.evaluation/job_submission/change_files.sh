for dir in "/u/flashscratch/k/keithgmi/S2_dataset_igor/S2_dataset/datasets/TRA/"*; do
	echo "In the directory $dir"
	for file in ${dir}/*; do
		cleanedname=${file##*/}
		mv $file ${dir}/TRA.${cleanedname}
		echo "Changed $cleanedname to TRA.${cleanedname}"
	done
done
