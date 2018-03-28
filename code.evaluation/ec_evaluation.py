
######################################################################
# Evaluation Code for Error Correction Benchmarking
#   project zar-lab ucla
#   3/27/18

#  Functions Contained: analyze_corrections,
######################################################################

# TODO:
#    Proper logging
#    Be sure tool, read ID, etc. (relevant info) is being passed to the function. 


from Bio import pairwise2
from logging import log, error


def analyze_corrections(true_sequence, raw_sequence, ec_sequence):
    """Keith Mitchell (keithgmitchell@g.ucla.edu).
        Function: Analyze true, raw(error_prone), and flawed/flawless error corrected reads
        Input 1: (string) true_sequence to be compared to raw and tool error corrected seq.
        Input 2: (string) raw_sequence (error prone sequence) that is to be compare to true and error corrected seq.
        Input 3: (string) ec_sequence (error corrected sequence) to be analyzed for flawed/flawless error correction
        Returns:
            Object 1: (dictionary) stats_dict which has the base level counts for the sequence:
                EX:        stats_dict = {'TN':0, 'TP':0, 'FN':0, 'FP':0, 'INDEL':0, 'TRIM': 0}
            Object 2: (string) seq_ID which dictates the read level classification (one of the following list):
                EX:        "TN", "FP(NORMAL)", "FP(INDEL)", "FP(TRIMMING)", "TP", "FN"
    """

    ## Series of global alignments that act as a sort of multiple sequence aligner.
    ## this performs a star based "MSA" assuming that True and Raw reads are the most similar(due to potential trims)
    # 1. Alignment 1- true_sequence|raw_sequence = true_2, raw_3
    # 2. Alignment 2- true_2|ec_sequence = true_3, ec_3

    alignments = pairwise2.align.globalms(true_sequence, raw_sequence, 5, -4, -10, -0.1)

    true_2 = alignments[0][0]
    raw_3 = alignments[0][1]

    alignments_2 = pairwise2.align.globalms(true_2, ec_sequence, 5, -4, -7, -0.1)

    true_3 = alignments_2[0][0]
    ec_3 = alignments_2[0][1]

    #TODO: Log these?
    #print "True:", true_3
    #print "Raw: ", raw_3
    #print "EC:  ", ec_3

    # base level statistics now that there is an "MSA" that we can compare.
    stats_dict = {'TN': 0, 'TP': 0, 'FN': 0, 'FP': 0, 'INDEL': 0, 'TRIM': 0}

    # check to make sure the "MSA" is same length... hopefully this should always be the case
    if len(true_3) == len(raw_3) == len(ec_3):
        # iterate through each column of the "MSA"
        trim_marker = 0
        trim = False
        for true_bp, raw_bp, ec_bp in zip(true_3, raw_3, ec_3):
            if true_bp == raw_bp == ec_bp:
                stats_dict['TN'] += 1
            elif true_bp == raw_bp != ec_bp:
                stats_dict['FP'] += 1
            elif true_bp != raw_bp != ec_bp and ec_bp == true_bp:
                stats_dict['TP'] += 1
            elif true_bp != raw_bp == ec_bp:
                stats_dict['FN'] += 1

            if (ec_bp == "-") and trim_marker == 0:
                stats_dict['TRIM'] += 1
                # stats_dict['FP'] -= 1
                trim = True
            elif (ec_bp == "-") and trim is True:
                stats_dict['TRIM'] += 1
                # stats_dict['FP'] -= 1
            elif (true_bp == "-") or (raw_bp == "-") or (ec_bp == "-"):
                stats_dict['INDEL'] += 1
                # stats_dict['FP'] -= 1
                trim = False
            else:
                trim = False
            trim_marker += 1

        if ec_bp == "-":
            for backwards_ec_bp in reversed(ec_3):
                if backwards_ec_bp == '-':
                    stats_dict['INDEL'] -= 1
                    stats_dict['TRIM'] += 1
                else:
                    break

        ##this portion decides what to classify the sequence as a whole as once the bases have been analyzed
        seq_classes = ["TN", "FP(NORMAL)", "FP(INDEL)", "FP(TRIMMING)", "TP", "FN"]
        seq_ID = ""
        if stats_dict['TN'] == len(true_3):
            seq_ID = seq_classes[0]
        elif stats_dict['FP'] != 0 and stats_dict['INDEL'] == 0 and stats_dict['TRIM'] == 0:
            seq_ID = seq_classes[1]
        elif stats_dict['FP'] != 0 and stats_dict['INDEL'] != 0:
            seq_ID = seq_classes[2]
        elif stats_dict['FP'] != 0 and stats_dict['TRIM'] != 0:
            seq_ID = seq_classes[3]
        elif stats_dict['TP'] != 0 and stats_dict['FP'] == 0:
            seq_ID = seq_classes[4]
        else:
            seq_ID = seq_classes[5]

        print "BASE LEVEL: ", stats_dict
        print "READ LEVEL: ", seq_ID

        return stats_dict, seq_ID

    else:
        # TODO: Log the name of the read and other pertenant info.
        # log.error(true_3, raw_3, ec_3)... look at apeiron code for library
        return None, None


### Aggregate the results from each read into a data structure that can easily incorporate into excel.
### using the tool, dataset, and sequence ID.


#Code for testing.
'''
true_sequence = 'ACGTGGTCCA'
raw_sequence = 'ACGTTGTCGA'
ec_sequence = 'TGGCGG'

analyze_corrections(true_sequence, raw_sequence, ec_sequence)
'''

