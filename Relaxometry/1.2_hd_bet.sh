# Claudia Rodriguez-Sobstel
# November 2022
# Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA

# GBGABA BRAIN DATA ANALYSIS
# 1.2_hd_bet.sh will run brain extraction on MP2_UNI image (output from QUIT) so it can be used to mask the T1 and UNI images
# Uses HD-BET, available from https://github.com/MIC-DKFZ/HD-BET

#!/bin/bash

# specify paths:
bids_path=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed

# go to bids path:
cd $bids_path


#---- for individual pre-processing (comment this section out for group pre-processing):

# obtain user input (for individual pre-processing purposes),
# to specify participant ID and session number:
read -p "Participant ID (in BIDS format, with sub- in front, e.g. sub-W1002): " i
read -p "Session ID, with ses- in front, e.g. ses-01: " ses

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
    
        # if there is an MP2 UNI image, then mask it:
        if [ -e ${derivative_path}/${i}/${ses}/MP2_UNI.nii.gz ]; then
            echo "Masking UNI image for ${i} ${ses}"
            hd-bet -i ${derivative_path}/${i}/${ses}/MP2_UNI.nii.gz -o ${derivative_path}/${i}/${ses}/${i}_${ses} -device cpu -mode fast -tta 0
            
        # otherwise, tell user it does not exist:
        else
            echo "MP2_UNI file does not exist for ${i} ${ses}"
            
        fi
        
    done
    
done
