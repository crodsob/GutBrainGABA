# Claudia Rodriguez-Sobstel
# November 2022
# Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA

# GBGABA BRAIN DATA ANALYSIS
# 1.1_quit.sh will run quit commands to create complex data file and T1 image from MP2RAGE data

#!/bin/bash

# specify paths:
bids_path=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
json_path=/Volumes/gold/cinn/2020/gbgaba/scripts_claudia/code

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
    
        # go to derivatives directory:
        cd ${derivative_path}/${i}/${ses}
        
        # create complex image:
        echo "Creating complex image for ${i} ${ses}"
            qi complex -m ${derivative_path}/${i}/${ses}/${i}_${ses}_mag.nii.gz -p ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad.nii.gz -X ${derivative_path}/${i}/${ses}/${i}_${ses}_mp2_x.nii
        
        # create T1 and UNI images:
        echo "Creating T1 and UNI images for ${i} ${ses}"
            qi mp2rage ${derivative_path}/${i}/${ses}/${i}_${ses}_mp2_x.nii --json=${json_path}/mp2rage.json --beta=10000

    done
    
done
