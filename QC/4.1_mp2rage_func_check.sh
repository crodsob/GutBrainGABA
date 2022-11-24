# Claudia Rodriguez-Sobstel
# November 2022

# GBGABA BRAIN DATA ANALYSIS
# 4.1_mp2rage_func_check.sh opens up magnitude, phase, and functional scans in FSL for quality insepction.

#!/bin/bash

# load fsl - if you are using a machine other than the virtual machine at UoR,
# you can comment out this line:
module load fsl6.0

# specify paths:
bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS

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

        # check the files in FSL for any potential quality issues:
        echo "Checking files for participant ${i} ${ses} for any potential quality issues."
            fsleyes ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_phase_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI2_phase_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_magnitude_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI2_magnitude_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_UNI_mp2rage.nii.gz ${bids_path}/${i}/${ses}/func/${i}_${ses}_task-rest_bold.nii.gz

        echo "Quality checks for ${i} ${ses} complete."

    done

done

