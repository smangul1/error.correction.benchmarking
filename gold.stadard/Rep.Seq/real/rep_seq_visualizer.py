#####################################################################################
# Code to visualize the grouping size for the UMIs
#   project zar-lab ucla
#   4/30/18
#   supervisor: Serghei Mangul
#   author: Keith Mitchell


#  Functions Contained: umi_group, handle_UMIs
#####################################################################################

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

def handle_UMIs(base_dir_join, files):
    umi_dict = {}
    for file in files:
        fastq_parser = SeqIO.parse(file, 'fastq')
        marker = 0
        for read in fastq_parser:

            if marker < 500000:

                start = read.seq[0:12]
                end = read.seq[len(read.seq)-12: len(read.seq)]
                trim = read.seq[12:len(read.seq)-12]
                umi_group(umi_dict, start, end, trim)
                marker += 1

            else:
                break



    # with open("help.txt", 'w') as write_csv:
    #     open_csv = csv.writer(write_csv)
    data = []
    for item in umi_dict.items():
        # open_csv.writerow('')
        # open_csv.writerow( [item[0],] )

        data.append(len(item[1]))
        # for value in item[1]:
        #     open_csv.writerow( [str(value), ])

    binwidth = 5
    plt.hist(data, bins=range(min(data), max(data) + binwidth, binwidth))
    #plt.hist(plot_list)
    plt.show()


if __name__ == "__main__":
    try:
        base_dir = sys.argv[1]
    except:
        #logging.warn('Example: python rep_seq.py "C:\Users\Amanda Beth Chron\Desktop\Research\EC3\gold.stadard\Rep.Seq\real\data"')
        logging.warn(
            'Example: python rep_seq.py "C:\Users\Amanda Beth Chron\Desktop\rep_seq_testing"')
        sys.exit()
    base_dir_join = os.path.join(str(base_dir))
    file_names = os.listdir(base_dir_join)
    umis = handle_UMIs(base_dir, file_names)






