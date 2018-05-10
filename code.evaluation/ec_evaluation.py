#####################################################################################
# Evaluation Code for Error Correction Benchmarking
#   zar-lab ucla
#   4/20/18
#   supervisor: Serghei Mangul
#   author: Keith Mitchell

#  Functions Contained: msa, analyze_bases, analyze_reads
#####################################################################################

from Bio import pairwise2, SeqIO
from ec_data_compression import store_base_data, store_read_data, baseline, data_compression, my_log
import os
import sys
import csv
import argparse


def msa(true_sequence, raw_sequence, ec_sequence, description):

    alignments = pairwise2.align.globalms(true_sequence, raw_sequence, 5, -4, -10, -0.1)

    true_2 = alignments[0][0]
    raw_3 = alignments[0][1]

    alignments_2 = pairwise2.align.globalms(true_2, ec_sequence, 5, -4, -7, -0.1)

    true_3 = alignments_2[0][0]
    ec_3 = alignments_2[0][1]

    #TODO: Log these?
    print description
    print "True:", true_3
    print "Raw: ", raw_3
    print "EC:  ", ec_3

    return true_3, raw_3, ec_3


def analyze_bases(true_3, raw_3, ec_3):

    """
            Function: Analyze true, raw(error_prone), and flawed/flawless error corrected reads
            Input 1: (string) true_sequence to be compared to raw and tool error corrected seq.
            Input 2: (string) raw_sequence (error prone sequence) that is to be compare to true and error corrected seq.
            Input 3: (string) ec_sequence (error corrected sequence) to be analyzed for flawed/flawless error correction
            Returns:
                Object 1: (dictionary) stats_dict which has the base level counts for the sequence:
                    EX:        stats_dict = {'TN':0, 'TP':0, 'FN':0, 'FP':0, 'INDEL':0, 'TRIM': 0}
    """

    #TODO this function here
    # base level statistics now that there is an "MSA" that we can compare.
    stats_dict = {'TN': 0, 'TP': 0, 'FN': 0, 'FP': 0, 'INDEL': 0, 'TRIM': 0}
    position_calls = {}

    # check to make sure the "MSA" is same length... hopefully this should always be the case
    if len(true_3) == len(raw_3) == len(ec_3):
        # iterate through each column of the "MSA"
        trim_marker, pos_marker = 0, 1
        trim = False
        for true_bp, raw_bp, ec_bp in zip(true_3, raw_3, ec_3):
            if true_bp == raw_bp == ec_bp:
                stats_dict['TN'] += 1
            elif true_bp == raw_bp != ec_bp:
                stats_dict['FP'] += 1
                position_calls[pos_marker] = ['FP', true_bp, raw_bp, ec_bp]
            elif true_bp != raw_bp != ec_bp and ec_bp == true_bp:
                stats_dict['TP'] += 1
                position_calls[pos_marker] = ['TP', true_bp, raw_bp, ec_bp]
            elif true_bp != raw_bp == ec_bp:
                stats_dict['FN'] += 1
                position_calls[pos_marker] = ['FN', true_bp, raw_bp, ec_bp]

            if (ec_bp == "-") and trim_marker == 0:
                stats_dict['TRIM'] += 1
                stats_dict['FP'] -= 1
                position_calls[pos_marker] = ['TRIM', true_bp, raw_bp, ec_bp]
                trim = True
            elif (ec_bp == "-") and trim is True:
                stats_dict['TRIM'] += 1
                stats_dict['FP'] -= 1
                position_calls[pos_marker] = ['TRIM', true_bp, raw_bp, ec_bp]
            elif (true_bp == "-") or (raw_bp == "-") or (ec_bp == "-"):
                stats_dict['INDEL'] += 1
                stats_dict['FP'] -= 1
                trim = False
                position_calls[pos_marker] = ['INDEL', true_bp, raw_bp, ec_bp]

            else:
                trim = False
            trim_marker += 1
            pos_marker += 1

        pos_marker -= 1
        if ec_bp == "-":
            stats_dict['FP']+=1
            for true_bp, raw_bp, ec_bp in zip(reversed(true_3), reversed(raw_3), reversed(ec_3)):
                if ec_bp == '-':
                    stats_dict['INDEL'] -= 1
                    stats_dict['TRIM'] += 1
                    position_calls[pos_marker] = ['TRIM', true_bp, raw_bp, ec_bp]
                else:
                    break
                pos_marker -= 1
        length = len(true_3)
        return stats_dict, length, position_calls

    else:
        return None


def analyze_read(stats_dict, length):

    seq_classes = ["TN", "FP(NORMAL)", "FP(INDEL)", "FP(TRIMMING)", "TP", "FN"]

    # If all bases are the TN then the read is a TN.
    if stats_dict['TN'] == length:
        return seq_classes[0]

    # If there are normal FP but no other FP(INDEL/trim) then the read is a normal FP.
    elif stats_dict['FP'] != 0 and stats_dict['INDEL'] == 0 and stats_dict['TRIM'] == 0:
        return seq_classes[1]

    # Next if there are FP from trimming then the read is as well.
    elif stats_dict['TRIM'] != 0:
        return seq_classes[3]

    # Next if there are FP from INDEL then the read is as well.
    elif stats_dict['INDEL'] != 0:
        return seq_classes[2]

    # If there are any TP bases and no FN bases then the read is a TP
    elif stats_dict['TP'] != 0 and stats_dict['FP'] == 0 and stats_dict['FN'] == 0:
        return seq_classes[4]

    # Otherwise the read is a FN
    else:
        return seq_classes[5]


def find_match_pe(fastq_1, fastq_2, true):
    for rec_1, rec_2 in zip(fastq_1, fastq_2):
        #TODO
        check_1 = rec_1.description.split(' ')
        check_2 = rec_2.description.split(' ')
        if true == check_1[0]:
            return rec_1
        elif true == check_2[0]:
            return rec_2

    message = 'It seems that no match was found for the sequence (Paired End)'
    #my_log(true, message)
    return None


def find_match_se(fastq, true):
    for rec in fastq:
        #TODO
        check = rec.description.split(' ')
        if true == check[0]:
            return rec

    message = 'It seems that no match was found for the sequence (Single End)'
    #my_log(true, message)
    return None


def handle_files(true_check, true_rec, two_ec, two_raw, fastq_raw1_parser, fastq_raw2_parser, fastq_ec1_parser, fastq_ec2_parser):

    if two_raw is True:
        raw_rec = find_match_pe(fastq_raw1_parser, fastq_raw2_parser, true_check[0])
    else:
        raw_rec = find_match_se(fastq_raw1_parser, true_check[0])

    if raw_rec is not None:
        if two_ec is True:
            ec_rec = find_match_pe(fastq_ec1_parser, fastq_ec2_parser, true_check[0])
        else:
            ec_rec = find_match_se(fastq_ec1_parser, true_check[0])

        if ec_rec is not None:
            alignment = msa(true_rec.seq, raw_rec.seq, ec_rec.seq, ec_rec.description)
            base_counts = analyze_bases(alignment[0], alignment[1], alignment[2])

            if base_counts is None:
                message = "FAILURE: Base count == 'None'(improper MSA) [TRUE: %s], [RAW: %s], [EC: %s]" % (
                true_rec.description, raw_rec.description, ec_rec.description)
                print message
                #my_log(base_dir_join, true_filename, message)

            else:
                position_calls = base_counts[2]
                length = base_counts[1]
                base_stats = base_counts[0]
                print base_stats
                read_class = analyze_read(base_stats, length)

                # TODO fix this...
                end_file_directory = ec1_filename.split('/')

                base_dir_join = os.path.join(str(base_dir))
                store_base_data(base_dir_join, end_file_directory[-1], ec_rec, length, base_stats)
                store_read_data(base_dir_join, end_file_directory[-1], ec_rec, read_class)
                baseline(base_dir_join, end_file_directory[-1], ec_rec, length, base_stats)
                data_compression(base_dir_join, end_file_directory[-1], ec_rec, length, position_calls)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Produces EC Evaluation for either paired-end or single-end sequences.\
                                                 takes either 6, 5, or 4 arguments.( will adjust if needed)')

    parser.add_argument('-base_dir', help='This is the directory to produce the raw sequences to', required=True)
    parser.add_argument('-true_1', help='This is the true file to be evaluated.', required=True)
    parser.add_argument('-true_2', help='This is the true file to be evaluated.', required=False)
    parser.add_argument('-raw_1', help='This is the raw file to be evaluated.', required=True)
    parser.add_argument('-raw_2', help='This is the second raw file, if paired-end, to be evaluated.', required=False)
    parser.add_argument('-ec_1', help='This is the ec file to be evaluated.', required=True)
    parser.add_argument('-ec_2', help='This is the second ec file, if paired-end, to be evaluated.', required=False)


    args = vars(parser.parse_args())
    base_dir = args['base_dir']
    true1_filename = args['true_1']
    true2_filename = args['true_2']
    raw1_filename = args['raw_1']
    raw2_filename = args['raw_2']
    ec1_filename = args['ec_1']
    ec2_filename = args['ec_2']

    #TODO make this a dictionary so it is faster maybe combine files from the very beginning.
    fastq_true1_parser = SeqIO.parse(os.path.join(str(true1_filename)), 'fastq')

    two_ec = False
    fastq_ec2_parser = ''
    if ec2_filename is not None and ec2_filename != '':
        fastq_ec2_parser = SeqIO.parse(os.path.join(str(ec2_filename)), 'fastq')
        two_ec = True

    two_raw = False
    fastq_raw2_parser = ''
    if raw2_filename is not None and raw2_filename != '':
        fastq_raw2_parser = SeqIO.parse(os.path.join(str(raw2_filename)), 'fastq')
        two_raw = True

    two_true = False
    if true2_filename is not None and true2_filename != '':
        fastq_true2_parser = SeqIO.parse(os.path.join(str(true2_filename)), 'fastq')
        two_true = True

    if two_true == True:
        for true1_rec, true2_rec in zip(fastq_true1_parser, fastq_true2_parser):
            true_check1 = true1_rec.description.split(' ')
            true_check2 = true2_rec.description.split(' ')

            fastq_ec1_parser = SeqIO.parse(os.path.join(str(ec1_filename)), 'fastq')
            fastq_raw1_parser = SeqIO.parse(os.path.join(str(raw1_filename)), 'fastq')
            fastq_ec2_parser = SeqIO.parse(os.path.join(str(ec2_filename)), 'fastq')
            fastq_raw2_parser = SeqIO.parse(os.path.join(str(raw2_filename)), 'fastq')

            handle_files(true_check1, true1_rec, two_ec, two_raw, fastq_raw1_parser, fastq_raw2_parser, fastq_ec1_parser, fastq_ec2_parser)
            handle_files(true_check2, true2_rec, two_ec, two_raw, fastq_raw1_parser, fastq_raw2_parser, fastq_ec1_parser, fastq_ec2_parser)
    else:
        for true_rec in fastq_true1_parser:
            true_check = true_rec.description.split(' ')

            fastq_ec1_parser = SeqIO.parse(os.path.join(str(ec1_filename)), 'fastq')
            fastq_raw1_parser = SeqIO.parse(os.path.join(str(raw1_filename)), 'fastq')
            fastq_ec2_parser = SeqIO.parse(os.path.join(str(ec2_filename)), 'fastq')
            fastq_raw2_parser = SeqIO.parse(os.path.join(str(raw2_filename)), 'fastq')

            handle_files(true_check, two_ec, two_raw, fastq_raw1_parser, fastq_raw2_parser, fastq_ec1_parser, fastq_ec2_parser)


    message = "SUCCESS: %s, %s" % (ec1_filename, ec2_filename)
    #my_log(true1_filename, message)



