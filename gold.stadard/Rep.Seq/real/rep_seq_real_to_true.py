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

#   slack more

#   how should I be handling the quality scores????? OOOPPS

#   if the server is a threaded process is it best not to close files



from Bio import pairwise2, SeqIO
import os
import logging
import sys
import csv
import matplotlib.pyplot as plt
import numpy as np


def umi_group(umi_dict, start, end, trim):
    total_umi = str(start), str(end)
    if total_umi in umi_dict.keys():
        umi_dict[total_umi].append(str(trim))
    else:
        umi_dict[total_umi] = [str(trim), ]

def get_consensus(base_dict):
    for item in base_dict.items():
        if item[1]/base_dict['Total'] >= 0.8:
            return item[0]
    return None

def write_true(true, filenames):
    return 0

def produce_counts(dict_item):
    base_dict = {'A': 0, 'C': 0, 'G': 0, 'T': 0, 'Total': 0}
    pos_list = [base_dict for x in range(0, len(item[0]))]
    for read in dict_item[1]:
        for base, base_count in zip(read, pos_list):
            base_dict[base] += 1
            base_dict['Total'] += 1


def handle_UMIs(files):
    umi_dict = {}
    for file in files:
        fastq_parser = SeqIO.parse(file, 'fastq')
        marker = 0
        for read in fastq_parser:

            start = read.seq[0:12]
            end = read.seq[len(read.seq)-12: len(read.seq)]
            trim = read.seq[12:len(read.seq)-12]

            #fix this
            umi_group(umi_dict, start, end, trim)
            marker += 1


    # with open("help.txt", 'w') as write_csv:
    #     open_csv = csv.writer(write_csv)
    # might want to make some adjustments here based on what to do based on question for serghei above
    # can just move this all in the file level for loop.... I think it would be best

    data = []
    for item in umi_dict.items():
        # in case I want to output groups again
        # open_csv.writerow('')
        # open_csv.writerow( [item[0],] )
        # data.append(len(item[1]))
        # for value in item[1]:
        #     open_csv.writerow( [str(value), ])
        try:
            
            #going to actually need to pass full sequence name somewhere above to print true from

            counts = produce_counts(item)
            consensus = [count for x in range(0, len(counts))]
            write_true(consensus, files)

        except:
            print "Error to log file...."



if __name__ == "__main__":
    try:
        base_dir = sys.argv[1]
    except:
        #logging.warn('Example: python rep_seq.py "C:\Users\Amanda Beth Chron\Desktop\Research\EC3\gold.stadard\Rep.Seq\real\data"')
        logging.warn(
            'Example: python rep_seq.py "C:\Users\Amanda Beth Chron\Desktop\rep_seq_testing"')
        sys.exit()

    base_dir_join = os.path.join(str(base_dir))
    list_dir = os.listdir(base_dir_join)
    umis = handle_UMIs(list_dir)






