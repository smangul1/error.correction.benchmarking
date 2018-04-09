#############################################################################################
# Data Storage for Error Correction Benchmarking
#   project zar-lab ucla
#   4/5/18

#  Functions Contained: store_base_data, store_read_data, baseline, data, compression
#############################################################################################


import os
import logging
import sys
import csv

#What if these directories are running multiples processes at once?

def my_log(file_name, message):
    with open( 'logging.txt', 'a') as logging_out:
        logging = csv.writer(logging_out, delimiter='\t')
        logging.writerow([file_name, message])


def store_base_data(base_dir_join, file_name, read_name, length, base_counts):
    with open(base_dir_join + '/base_data/' + file_name + '.txt', 'a') as baseout:
        baseout = csv.writer(baseout, delimiter='\t')
        baseout.writerow([read_name.description, length, base_counts['TP'], base_counts['FP'], base_counts['FN'], base_counts['TN'], base_counts['INDEL'], base_counts['TRIM']])


def store_read_data(base_dir_join, file_name, read_name, read_classification):
    with open(base_dir_join + '/read_data/' + file_name + '.txt', 'a') as readout:
        readout = csv.writer(readout, delimiter='\t')
        readout.writerow([read_name.description, read_classification])



def baseline(base_dir_join, file_name, read_name, length, base_counts):
    with open( base_dir_join + '/baseline_data/' + file_name + '.txt', 'a') as baseline_out:
        baseline_out = csv.writer(baseline_out, delimiter='\t')
        baseline_out.writerow([read_name.description, length, base_counts['TP'], base_counts['FP']])



def data_compression(base_dir_join, file_name, read_name, length, position_calls):
    with open( base_dir_join + '/data_compression/' + file_name + '.txt', 'a') as data_comp_out:
        data_comp = csv.writer(data_comp_out, delimiter='\t')
        for key, value in sorted(position_calls.iteritems()):
            position = key
            call, true_bp, raw_bp, ec_bp = value[0], value[1], value[2], value[3]
            data_comp.writerow([read_name.description, length, position, call, true_bp, raw_bp, ec_bp])



