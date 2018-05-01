#####################################################################################
# Evaluation Code for Error Correction Benchmarking
#   project zar-lab ucla
#   4/20/18
#   supervisor: Serghei Mangul
#   author: Keith Mitchell

#  Functions Contained: msa, analyze_bases, analyze_reads
#####################################################################################

# TODO:
#    Proper logging
#    Be sure tool, read ID, etc. (relevant info) is being passed to the function.


from Bio import pairwise2, SeqIO
from ec_data_compression import store_base_data, store_read_data, baseline, data_compression, my_log
import os
import logging
import sys
import csv


def msa(true_sequence, raw_sequence, ec_sequence, description):


    alignments = pairwise2.align.globalms(true_sequence, raw_sequence, 5, -4, -10, -0.1)

    true_2 = alignments[0][0]
    raw_3 = alignments[0][1]

    alignments_2 = pairwise2.align.globalms(true_2, ec_sequence, 5, -4, -7, -0.1)

    true_3 = alignments_2[0][0]
    ec_3 = alignments_2[0][1]

    #TODO: Log these?
    print description
    print "True:", true_3.replace('-', '')
    print "Raw: ", raw_3.replace('-', '')
    print "EC:  ", ec_3.replace('-', '')


    return true_3, raw_3, ec_3


def analyze_bases(true_3, raw_3, ec_3):

    """Keith Mitchell (keithgmitchell@g.ucla.edu).
            Function: Analyze true, raw(error_prone), and flawed/flawless error corrected reads
            Input 1: (string) true_sequence to be compared to raw and tool error corrected seq.
            Input 2: (string) raw_sequence (error prone sequence) that is to be compare to true and error corrected seq.
            Input 3: (string) ec_sequence (error corrected sequence) to be analyzed for flawed/flawless error correction
            Returns:
                Object 1: (dictionary) stats_dict which has the base level counts for the sequence:
                    EX:        stats_dict = {'TN':0, 'TP':0, 'FN':0, 'FP':0, 'INDEL':0, 'TRIM': 0}
    """

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

    """Keith Mitchell (keithgmitchell@g.ucla.edu).
        Function: Analyze true, raw(error_prone), and flawed/flawless error corrected reads
        Input 1: (string) true_sequence to be compared to raw and tool error corrected seq.
        Input 2: (string) raw_sequence (error prone sequence) that is to be compare to true and error corrected seq.
        Input 3: (string) ec_sequence (error corrected sequence) to be analyzed for flawed/flawless error correction
        Returns:
            Object 1: string - read level classification given the base counts passed to it for a given read:
                EX:        ["TN", "FP(NORMAL)", "FP(INDEL)", "FP(TRIMMING), "TP", "TN"]

    """

    ##this portion decides what to classify the sequence as a whole as once the bases have been analyzed
    seq_classes = ["TN", "FP(NORMAL)", "FP(INDEL)", "FP(TRIMMING)", "TP", "FN"]
    seq_ID = ""

    # If all bases are the TN then the read is a TN.
    if stats_dict['TN'] == length:
        seq_ID = seq_classes[0]

    # If there are normal FP but no other FP(INDEL/trim) then the read is a normal FP.
    elif stats_dict['FP'] != 0 and stats_dict['INDEL'] == 0 and stats_dict['TRIM'] == 0:
        seq_ID = seq_classes[1]

    # Next if there are FP from trimming then the read is as well.
    elif stats_dict['TRIM'] != 0:
        seq_ID = seq_classes[3]

    # Next if there are FP from INDEL then the read is as well.
    elif stats_dict['INDEL'] != 0:
        seq_ID = seq_classes[2]

    # If there are any TP bases and no FN bases then the read is a TP
    elif stats_dict['TP'] != 0 and stats_dict['FP'] == 0 and stats_dict['FN'] == 0:
        seq_ID = seq_classes[4]

    # Otherwise the read is a FN
    else:
        seq_ID = seq_classes[5]

    return seq_ID


if __name__ == "__main__":

    try:
        #Todo: make this for taking in strings.
        base_dir = sys.argv[1]
        true_filename = sys.argv[2]
        raw1_filename = sys.argv[3]
        raw2_filename = sys.argv[4]
        ec1_filename = sys.argv[5]
        ec2_filename = sys.argv[6]
    except:
        logging.warn('Example: python ec_evaluation.py "C:\Users\Amanda Beth Chron\Desktop\Testing Reads" "IGH_sim_rl_50_cov_1.true.fastq" "IGH_sim_rl_50_cov_1_R1.fastq" "IGH_sim_rl_50_cov_1_R2.fastq" "IGH_sim_rl_50_cov_1_R1.fastq.corrected" "IGH_sim_rl_50_cov_1_R2.fastq.corrected"')
        sys.exit()

    base_dir_join = os.path.join(str(base_dir))
    fastq_ec1_parser = SeqIO.parse(base_dir_join + "/" + str(ec1_filename), 'fastq')
    fastq_ec2_parser = SeqIO.parse(base_dir_join + "/" + str(ec2_filename), 'fastq')
    fastq_raw1_parser = SeqIO.parse(base_dir_join + "/" + str(raw1_filename), 'fastq')
    fastq_raw2_parser = SeqIO.parse(base_dir_join + "/" + str(raw2_filename), 'fastq')
    fastq_true_parser = SeqIO.parse(base_dir_join + "/" + str(true_filename), 'fastq')

    #TODO: clean this up depending on what is needed for the files to be inputted.
    for true_rec in fastq_true_parser:
        true_check = true_rec.description
        fastq_raw1_parser = SeqIO.parse(base_dir_join + "/" + str(raw1_filename), 'fastq')
        fastq_raw2_parser = SeqIO.parse(base_dir_join + "/" + str(raw2_filename), 'fastq')
        for raw1_rec, raw2_rec in zip(fastq_raw1_parser, fastq_raw2_parser):
            raw1_check = raw1_rec.description.split(' ')
            raw2_check = raw2_rec.description.split(' ')
            #print "1:    ", true_check, raw1_check[0], raw2_check[0]
            raw_rec = None
            if true_check == raw1_check[0]:
                raw_rec = raw1_rec
            elif true_check == raw2_check[0]:
                raw_rec = raw2_rec

            if raw_rec is not None:
                fastq_ec1_parser = SeqIO.parse(base_dir_join + "/" + str(ec1_filename), 'fastq')
                fastq_ec2_parser = SeqIO.parse(base_dir_join + "/" + str(ec2_filename), 'fastq')
                for ec1_rec, ec2_rec in zip(fastq_ec1_parser, fastq_ec2_parser):
                    ec1_check = ec1_rec.description[0:8]
                    ec2_check = ec2_rec.description[0:8]
                    #print "2:    ", true_check, ec1_check, ec2_check
                    ec_rec = None
                    if true_check == ec1_check:
                        ec_rec = ec1_rec
                    elif true_check == ec2_check:
                        ec_rec = ec2_rec

                    if ec_rec is not None:
                        alignment = msa(true_rec.seq, raw_rec.seq, ec_rec.seq, ec_rec.description)
                        base_counts = analyze_bases(alignment[0], alignment[1], alignment[2])

                        if base_counts is None:
                            message = "FAILURE: Base count == 'None'(improper MSA) [TRUE: %s], [RAW: %s], [EC: %s]" %(true_rec.description, raw_rec.description, ec_rec.description)
                            my_log(true_filename, message)
                            print ""
                            print ""
                        else:
                            position_calls = base_counts[2]
                            length = base_counts[1]
                            base_stats = base_counts[0]
                            read_class = analyze_read(base_stats, length)

                            print base_stats
                            print read_class
                            print ""


                        break
                break


    # store_base_data(base_dir_join, ec_filename, ec_rec, length, base_stats)
    # store_read_data(base_dir_join, ec_filename, ec_rec, read_class)
    # baseline(base_dir_join, ec_filename, ec_rec, length, base_stats)
    # data_compression(base_dir_join, ec_filename, ec_rec, length, position_calls)


    message = "SUCCESS: %s, %s" % (ec1_filename, ec2_filename)
    my_log(true_filename, message)

        #log when the sum is not equal to the length aka something went wrong (try and except?)
        #logging.warn('Input file name, ouput file name not provided')



