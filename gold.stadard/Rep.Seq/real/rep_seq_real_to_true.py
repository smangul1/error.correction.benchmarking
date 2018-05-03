#####################################################################################
# Code to produce the true reads for tools ec analysis from rep seq real reads
#   project zar-lab ucla
#   4/30/18
#   supervisor: Serghei Mangul
#   author: Keith Mitchell

#   Functions Contained: umi_group, handle_UMIs, produce_true, get_consensus
#####################################################################################

# question for Serghei tomorrow:

#   do we want all of these files together (meant to look into the paper but thought I would check to see if you know
#       off the top of your head

#   check reverse reads

#   is it ok if a base does not get corrected, as in there is no consensus

#   todo: make code in general fail gracefully and go to a log file

#   how should I be handling the quality scores????? OOOPPS
#       quality = max base pair/ total

#   if the server is a threaded process is it best not to close files


from Bio import pairwise2, SeqIO
import os
import logging
import sys
import csv


def my_log(file_name, message):
    with open( 'logging.txt', 'a') as logging_out:
        logging = csv.writer(logging_out, delimiter='\t')
        logging.writerow([file_name, message])


def write_true(true, grouped_dict, true_dir):
    for item in grouped_dict.items():
        with open(true_dir + item[1][2] + '%s%s' % ('_true','.fastq'), 'a') as true_out:

            UMIs = item[0].split(',')
            reconstruct_true = UMIs[0] + true + UMIs[1]
            quality = str.append('~' for x in range(0, len(reconstruct_true)))

            true_out.write(['@%s%s' % (true[1][1], "True")])
            true_out.write(reconstruct_true)
            true_out.write(quality)


def get_base_consensus(base_dict):
    for item in base_dict.items():
        if item[1]/base_dict['Total'] >= 0.8 and item[0] != 'Total':
            return item[0]
    return None


def produce_counts(dict_item):
    # returns a list of dicts for the counts
    pos_list = [dict({'Total': 0}) for x in range(0, len(dict_item[0][0]))]

    for read in dict_item:
        for base, base_count in zip(read[0], pos_list):
            if base in base_count.keys():
                base_count[base] += 1
            else:
                base_count[base] = 1
            base_count['Total'] += 1
    return pos_list


def umi_group(umi_dict, start, end, trim, description, file):
    total_umi = str(start), str(end)
    if total_umi in umi_dict.keys():
        umi_dict[total_umi].append([str(trim), description, file])
    else:
        umi_dict[total_umi] = [[str(trim), description, file], ]


def handle_UMIs(files, true_dir):
    umi_dict = {}
    for file in files:
        fastq_parser = SeqIO.parse(file, 'fastq')

        #length of the sequences here are 238 but why does the file say 152
        for read in fastq_parser:
            start = read.seq[0:12]
            end = read.seq[len(read.seq)-12: len(read.seq)]
            trim = read.seq[12:len(read.seq)-12]
            umi_group(umi_dict, start, end, trim, read.description, file)

    for item in umi_dict.items():

        # item = {UMI front, UMI end: ([trimmed sequence, description, file]...)}
        # take the list of grouped sequences (those that are greater then 5)
        if len(item[1]) > 5:
            counts = produce_counts(item[1])
            consensus = [get_base_consensus(base_counts) for base_counts in counts]

            if None not in consensus:
                write_true(consensus, item, true_dir)
            else:
                # my_log(item[0], "No consensus found....")
                continue

        # with open("help.txt", 'a') as write_csv:

        # open_csv = csv.writer(write_csv)
        # open_csv.writerow('')
        # open_csv.writerow( [item[0],] )
        #
        # for value in item[1]:
        #      open_csv.writerow( [str(value[0]), ])


if __name__ == "__main__":
    try:
        true_dir = sys.argv[1]
        raw_dir = sys.argv[2]
    except:
        #logging.warn('Example: python rep_seq_real_to_true.py "C:\Users\Amanda Beth Chron\Desktop\Research\EC3\gold.stadard\Rep.Seq/real"')
        #logging.warn('Example: python rep_seq_real_to_true.py "C:\Users\Amanda Beth Chron\Desktop\Research\EC3\gold.stadard\Rep.Seq\real\data\"')
        # python rep_seq_real_to_true.py "/u/flashscratch/k/keithgmi/" "/u/home/s/serghei/project/EC_survey/RepSeq_real/"
        sys.exit()

    base_dir_join = os.path.join(str(raw_dir))
    list_dir = os.listdir(base_dir_join)
    files = [base_dir_join + file for file in list_dir]
    umis = handle_UMIs(files, true_dir)






