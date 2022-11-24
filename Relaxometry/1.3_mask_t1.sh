# Claudia Rodriguez-Sobstel
# November 2022
# Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA

# GBGABA BRAIN DATA ANALYSIS
# 1.3_mask_t1.sh will mask the T1 and UNI images (output from quit) using the mask created by HD-BET

#!/bin/bash

# specify paths:
bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
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


        # if the T1 and UNI images exist in the derivative path, mask each one:
        if [ -e ${derivative_path}/${i}/${ses}/MP2_T1.nii.gz ]; then
            
            echo "Masking T1 and UNI images for ${i} ${ses} - outputs are ${i}_${ses}_MP2_T1_brain.nii.gz and ${i}_${ses}_MP2_UNI_brain.nii.gz "
            
            # mask the T1 image:
            fslmaths ${derivative_path}/${i}/${ses}/MP2_T1.nii.gz -mul ${derivative_path}/${i}/${ses}/${i}_${ses}_mask.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain.nii.gz
        
            # mask the UNI image:
            fslmaths ${derivative_path}/${i}/${ses}/MP2_UNI.nii.gz -mul ${derivative_path}/${i}/${ses}/${i}_${ses}_mask.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_UNI_brain.nii.gz
        
        # otherwise, state the MP2_T1 file does not exist:
        else
            echo "MP2_T1 file does not exist for ${i} ${ses}"
            
        fi
        
    done
    
done

