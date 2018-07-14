#!/bin/bash
echo $SGE_TASK_ID
./pre_pe_alltools.sh $1 $SGE_TASK_ID $2
