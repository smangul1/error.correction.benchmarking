#####################################################################################
# Compression Summary for Error Correction Benchmarking
#   zar-lab ucla
#   5/17/18
#   supervisor: Serghei Mangul
#   author: Keith Mitchell

#  Functions Contained: check_existence, append_summary
#####################################################################################


def check_existence(out_dir, file_name):
    if os.path.exists(out_dir + file_name):
        return 'a'  # append if already exists
    else:
        return 'w'  # make a new file if not


def append_summary(wrapper, kmer, read_data, base_data, ec_name, outdir, filename):
    read_sum = {"TN": 0, "TP": 0, "FN": 0, "FP(NORMAL)": 0, "FP(INDEL)": 0, "FP(TRIMMING)": 0, "Read Total": 0}
    base_sum = {"Total Bases": 0, "TP": 0, "FP(NORMAL)": 0, "FN": 0, "TN": 0, "FP(INDEL)": 0, "FP(TRIMMING)": 0}
    with open(read_data, 'r') as reads_csv, open(base_data, 'r') as base_csv:

        reads_reader = csv.reader(reads_csv, delimiter=',')
        for row in reads_reader:
            read_sum[str(row[1])] += 1

        base_reader = csv.reader(base_csv, delimiter=',')
        for row in base_reader:
            # NOTE: we take the "Read Total" here since we dont record TN reads but we record everything for
            # base evaluation so we know this is the number of reads that were analyzed
            read_sum["Read Total"] += 1

            # Aggregrate the base data per file
            base_sum["Total Bases"] += row[1]
            base_sum["TP"] += row[2]
            base_sum["FP(NORMAL)"] += row[3]
            base_sum["FN"] += row[4]
            base_sum["TN"] += row[1]-(row[2]+row[3]+row[4])
            base_sum["FP(INDEL)"] += row[5]
            base_sum["FP(TRIMMING)"] += row[6]

    
    type = check_existence(outdir, filename)
    with open(base_dir_join + file_name, type) as summaryout:
        summaryout = csv.writer(summaryout, delimiter=',')
        if type == 'w':
            summaryout.writerow("EC Filename", "Wrapper Name", "Kmer Size",
                                "Read - TP", "Read - TN", "Read - FN", "Read - FP(NORMAL)", "Read - FP(TRIMMING)", "Read - FP (INDEL)", "Total Reads",
                                "Base - TP", "Base - TN", "Base - FN", "Base - FP(NORMAL)",	"Base - FP(TRIMMING)", "Base - FP (INDEL)", "Total Bases")

        summaryout.writerow(ec_name, wrapper, kmer,
                            read_sum["TP"], read_sum["TN"], read_sum["FN"], read_sum["FP(NORMAL)"], read_sum["FP(TRIMMING)"], read_sum["FP(INDEL)"], read_sum["Read Total"],
                            base_sum["TP"], base_sum["TN"], base_sum["FN"], base_sum["FP(NORMAL)"], base_sum["FP(TRIMMING)"], base_sum["FP(INDEL)"], base_sum["Total Bases"])




if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Produces EC Evaluation for either paired-end or single-end sequences.\
                                                 takes either 6, 5, or 4 arguments.( will adjust if needed)')
    #TODO: do we need the gene length as well
    #TODO: should we specify the filename
    parser.add_argument('-wrapper', help='wrapper that was ran', required=True)
    parser.add_argument('-kmer', help='kmer size used to run the EC tool', required=True)
    parser.add_argument('-read_data', help='read data file from ec_evaluation', required=True)
    parser.add_argument('-base_data', help='base data file from ec_evaluation', required=True)
    parser.add_argument('-ec_name', help='name of the error corrected file produced from the wrapper', required=True)
    parser.add_argument('-outdir', help='name of the error corrected file produced from the wrapper', required=True)

    args = vars(parser.parse_args())
    wrapper = args['wrapper']
    kmer = args['kmer']
    read_data = args['read_data']
    base_data = args['base_data']
    ec_name = args['ec_name']
    out_dir = args['out_dir']

    filename='master_summary.txt'
    append_summary(wrapper, kmer, read_data, base_data, ec_name, out_dir, filename)