# Claudia Rodriguez-Sobstel
# November 2022

# GBGABA BRAIN DATA ANALYSIS
# 4.3_check_outputs.sh will check the FEAT and pyfMRIqc outputs for pre-processed file.

#!/bin/bash

# specify paths:
bids_path=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed

#---- for individual pre-processing (comment this section out for group pre-processing):
# obtain user input (for individual pre-processing purposes),
# to specify participant ID and session number:
read -p "Paricipant ID (in BIDS format, with sub- in front, e.g., sub-W1002): " i
read -p "Session ID, with ses- in front, e.g., ses-01: " ses

# for the specified participant, do the following:
for i in ${i}; do

    # go to participant bids directory:
    cd ${bids_path}/${i}

    # for the specified session, do the following:
    for ses in ${ses}; do
#-------------------------------------------------------------- individual pre-processing ends here


#---- for group pre-processing (comment this section out for individual pre-processing):
# subjects=( $(ls -d sub-* ))
# for sub in ${!subjects[@]}; do
#   i=${subjects[$sub]}
#   s=${i//$"sub-"/}
    
#   cd ${bids_path}/${i}
#   sessions=( $(ls -d ses-*))

#   for visit in ${!sessions[@]}; do
#      ses=${sessions[$visit]}
#-------------------------------------------------------------- group pre-processing ends here

        # open the pyfMRIqc output:
        echo "Opening pyfMRIqc output for ${i}_${ses}"
            open ${bids_path}/${i}/${ses}/func/pyfMRIqc_${i}_${ses}_task-rest_bold/pyfMRIqc_HTML_${i}_${ses}_task-rest_bold.html

        echo "Opened pyfMRIqc output for ${i}_${ses}"

        # open the FEAT preproc output:
        echo "Opening FEAT output for ${i}_${ses}"
            open ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/report_reg.html

        echo "Opened FEAT output for ${i}_${ses}"

    done
    
done
