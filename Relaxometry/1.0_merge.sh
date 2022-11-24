# Claudia Rodriguez-Sobstel
# November 2022
# Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA

# GBGABA BRAIN DATA ANALYSIS
# 1.0_merge.sh will merge magnitude and phase images acquired using MP2RAGE

#!/bin/bash

# load fsl - if you are using a machine other than the virtual machine at UoR,
# you can comment out this line:
module load fsl6.0

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


        # if the MP2RAGE file exists
        if [ -e ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_magnitude_mp2rage.nii.gz ]; then
        
            # make a derivative directory:
            echo "Making derivative directory for ${i}_${ses}"
                mkdir -p ${derivative_path}/${i}/${ses}/

            # merge the magnitude files:
            echo "Merging magnitude files for ${i} ${ses}"
                fslmerge -t ${derivative_path}/${i}/${ses}/${i}_${ses}_mag ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_magnitude_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI2_magnitude_mp2rage.nii.gz
            
            # reorient the mag image to standard orientation using FSL (to avoid issues when creating group template):
            echo "Reorienting mag file for ${i} ${ses}"
                fslreorient2std ${derivative_path}/${i}/${ses}/${i}_${ses}_mag.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_mag.nii.gz
            
            # merge the phase files:
            echo "Merging phase files for ${i} ${ses}"
                fslmerge -t ${derivative_path}/${i}/${ses}/${i}_${ses}_phase ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_phase_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI2_phase_mp2rage.nii.gz
            
            # convert phase images to radians:
            echo "Converting phase images to radians for ${i} ${ses}"
                fslmaths ${derivative_path}/${i}/${ses}/${i}_${ses}_phase -div 4096 -mul 3.141592653 ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad
            
            # reorient phase rad image to standard orientation using FSL (to avoid issues when creating group template):
            echo "Reorienting phase_rad file for ${i} ${ses}"
                 fslreorient2std ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad.nii.gz
                 
        # otherwise, advise there is no MP2RAGE data:
        else
            echo "No MP2RAGE data for ${i} ${ses}"
            
        fi
        
    done
    
done
    
