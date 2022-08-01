#!/bin/sh

subject_number=$1

echo $subject_number

### in this case the script folder is same as pwd but in other occasions change the path to your script directory

script_folder=/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/script

cd $script_folder

matlab -nosplash -r "step_8_first_level('$subject_number');exit;"
