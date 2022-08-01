#!/bin/sh

# Script to take list of subject names and performs 
# first level analysis


### Select the proper version of matlab

source /usr/local/apps/psycapps/config/matlab_bash

cd /MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/script/cluster

# Make sure to change this according to your account and that this folder exists
OUTPUT_LOG_DIR=$(pwd)/log_first_level
mkdir -p $OUTPUT_LOG_DIR

script_folder=$(pwd)

for subject_number in 301 304 306 309 310 312 313 316 318 319 320 322 323 324 326 328 330 331 333 334 336 340 341 342 401 406 407 410 411 412 413 414 416 418 420 422 423 424 425 426 427 428 429 430 431 432 433 434
do
    echo "Processing Subject $subject_number"
    qsub    -l h_rss=4G \
            -o ${OUTPUT_LOG_DIR}/matlab_${subject_number}.out \
            -e ${OUTPUT_LOG_DIR}/matlab_${subject_number}.err \
            $script_folder/first_level_call.sh $subject_number;       
done

