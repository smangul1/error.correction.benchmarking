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
import sys
import csv
import argparse

def write_true(true, group, true_dir):
    for item in group[1]:
        directories = item[2].split('/')
        with open(os.path.join(true_dir.strip('\r')) + 'true/' + directories[len(directories)-1].strip('fastq') + '%s%s' % ('_true','.fastq'), 'a') as true_out:
            UMIs = group[0]
            reconstruct_true = UMIs[0] + ''.join(true) + UMIs[1]
            quality_list = ['~' for x in range(0, len(reconstruct_true))]
            true_out.write('@%s' % (str(item[1]) + " True" + '\n'))
            true_out.write(reconstruct_true + '\n')
            true_out.write('+%s' % (str(item[1]) + " True" + '\n'))
            true_out.write(''.join(quality_list) + '\n')

def rewrite_raw(group, true_dir):
    for item in group[1]:
        directories = item[2].split('/')
        # with open(os.path.join(true_dir.strip('\r')) + '/' + directories[len(directories)-1] + '%s%s' % ('_true','.fastq'), 'a') as raw_out:
        with open(os.path.join(true_dir.strip('\r')) + 'raw/' + directories[len(directories) - 1].strip('.fastq') + '%s%s' % ('_raw', '.fastq'), 'a') as raw_out:
            UMIs = group[0]
            reconstruct_raw = UMIs[0] + ''.join(item[0]) + UMIs[1]
            quality_list = ['~' for x in range(0, len(reconstruct_raw))]
            true_out.write('@%s' % (str(item[1]) + " Raw" + '\n'))
            true_out.write(reconstruct_raw + '\n')
            true_out.write('+%s' % (str(item[1]) + " Raw" + '\n'))
            true_out.write(''.join(quality_list) + '\n')

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
    for file in files:
        umi_dict = {}
        fastq_parser = SeqIO.parse(file, 'fastq')

        for read in fastq_parser:

            start = read.seq[0:12]
            end = read.seq[len(read.seq)-12: len(read.seq)]
            trim = read.seq[12:len(read.seq)-12]
            umi_group(umi_dict, start, end, trim, read.description, file)


        count_loss = {"lost": 0 , "total": 0}
        for item in umi_dict.items():

            # item = {UMI front, UMI end: ([trimmed sequence, description, file]...)}
            # take the list of grouped sequences (those that are greater then 5)
            if len(item[1]) > 5:
                counts = produce_counts(item[1])
                consensus = [get_base_consensus(base_counts) for base_counts in counts]
                if None not in consensus:
                    write_true(consensus, item, true_dir)
                    rewrite_raw(item)
                else:
                    continue
            else:
                count_loss["lost"] += len(item[1])
            count_loss["total"] += len(item[1])

        print (file, count_loss["lost"], count_loss["total"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Produce True from Rep. Seq Raw')
    parser.add_argument('-input_dir', help = 'This is the directory to retrieve all rep seq raw data from.', required = True)
    parser.add_argument('-output_dir', help = 'This is the directory to create all true/and raw reads for testing tools.', required = True)
    args = vars(parser.parse_args())
    raw_dir = args['input_dir']
    true_dir = args['output_dir']

    print ("TRUE", true_dir)
    print ("RAW", raw_dir)
    list_dir = os.listdir(raw_dir.strip('\r'))
    print (list_dir)
    files = [raw_dir.strip('\r') + "/" + file for file in list_dir]
    umis = handle_UMIs(files, true_dir)






