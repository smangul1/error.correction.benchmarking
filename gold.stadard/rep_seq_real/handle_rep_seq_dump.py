#Code to produce the true reads for tools ec analysis from rep seq real reads
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


from __future__ import division
from Bio import pairwise2, SeqIO
import os
import sys
import csv
import argparse
import itertools

def check_existence(path):
    if os.path.exists(path):
        return 'a'  # append if already exists
    else:
        return 'w'  # make a new file if not

def write_true(true, group, true_dir):
    for item in group[1]:
        directories = item[2].split('/')
        path = os.path.join(true_dir.strip('\r')) + '/true/' + directories[len(directories)-1].replace('.fastq', "") + '%s%s' % ('_true','.fastq')
        with open(path, check_existence(path)) as true_out:
            UMIs = group[0]
            reconstruct_true = ''.join(true)
            quality_list = ['~' for x in range(0, len(reconstruct_true))]
            true_out.write('@%s' % (str(item[1]) + '\n'))
            true_out.write(reconstruct_true + '\n')
            true_out.write('+%s' % (str(item[1]) + '\n'))
            true_out.write(''.join(quality_list) + '\n')

def rewrite_raw(group, true_dir):  
    #print "NEW"
    #print ""
    for item in group[1]:
	#print item[0]

        directories = item[2].split('/')
        path = os.path.join(true_dir.strip('\r')) + '/raw/' + directories[len(directories) - 1].replace('.fastq', "") + '%s%s' % ('_raw', '.fastq')
        with open(path, check_existence(path)) as raw_out:
            UMIs = group[0]
            reconstruct_raw = ''.join(item[0])
            quality_list = item[3]
            raw_out.write('@%s' % (str(item[1]) + '\n'))
            raw_out.write(reconstruct_raw + '\n')
            raw_out.write('+%s' % (str(item[1]) + '\n'))
            raw_out.write(''.join(quality_list) + '\n')

def get_base_consensus(base_dict):
    for key in base_dict.keys():
        if base_dict[key]/base_dict['Total'] > 0.8 and key != 'Total':
            return key
    #print base_dict
    return None


def produce_counts(dict_item):

    pos_list = [{'Total': 0} for x in range(0, len(dict_item[0][0]))]
    for read in dict_item:
        for base, base_count in zip(read[0], pos_list):
            if base in base_count.keys():
                base_count[base] += 1
            else:
                base_count[base] = 1

            base_count['Total'] += 1
    return pos_list


def umi_group(umi_dict, start, end, trim, description, file, trimmed_quality):
    total_umi = str(start), str(end)
    if total_umi in umi_dict.keys():
        umi_dict[total_umi].append([str(trim), description, file, trimmed_quality])
    else:
        umi_dict[total_umi] = [[str(trim), description, file, trimmed_quality], ]


def handle_UMIs(files, true_dir):
    for file in files:
        umi_dict = {}
        fastq_parser = SeqIO.parse(file, 'fastq')
        for read in fastq_parser:
            start = read.seq[0:12]
            end = read.seq[len(read.seq)-12: len(read.seq)]
            trim = read.seq[12:len(read.seq)-12]
            quality = read.format("fastq").split("\n")[3]
	    quality_trim = quality[12:len(read.seq)-12]

	    umi_group(umi_dict, start, end, trim, read.description, file, quality_trim)

        count_loss = {"lost": 0 , "total": 0}
        for item in umi_dict.items():

            # item = {UMI front, UMI end: ([trimmed sequence, description, file]...)}
            # take the list of grouped sequences (those that are greater then 5
            #if len(item[1])>10:		
		#print "Check"   
	 	#for read in item[1]:
		   # print read[0]
		
		#print ""
		#for combination in itertools.combinations(item[1], 2):
		    #if combination[0][0]!=combination[1][0]:
			#print combination[0][0]
			#print combination[1][0]
            		#break
	        #print ""
	 
	    if len(item[1]) > 5:
		
                counts = produce_counts(item[1])
                consensus = [get_base_consensus(base_counts) for base_counts in counts]
	        #print "Errors?"
		#for object in item[1]:
		    #print object[0]
                #print ""
		#print consensus
		#print counts
		#print ""
		if None not in consensus:			
	            write_true(consensus, item, true_dir)
                    rewrite_raw(item, true_dir)
                else:
                    continue
            else:
                count_loss["lost"] += len(item[1])
            count_loss["total"] += len(item[1])

        print (file, count_loss["lost"], count_loss["total"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Produce True from Rep. Seq Raw')
    parser.add_argument('-input_file', help = 'This is the directory to retrieve all rep seq raw data from.', required = True)
    parser.add_argument('-output_dir', help = 'This is the directory to create all true/and raw reads for testing tools.', required = True)
    args = vars(parser.parse_args())
    raw_file = args['input_file']
    true_dir = args['output_dir']

    print ("TRUE", true_dir)
    print ("RAW", raw_file)
    #list_dir = os.listdir(raw_dir.strip('\r'))
    #print (list_dir)
    file_list = []
    file_list.append(raw_file)
    #files = [raw_dir.strip('\r') + "/" + file for file in list_dir]
    umis = handle_UMIs(file_list, true_dir)



