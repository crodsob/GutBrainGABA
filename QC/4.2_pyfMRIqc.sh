# Claudia Rodriguez-Sobstel
# November 2022

# GBGABA BRAIN DATA ANALYSIS 
# 4.2_pyfMRIqc.sh runs pyfMRIqc on the functional data and motion-corrected data.
# see https://drmichaellindner.github.io/pyfMRIqc/#input-parameter for guidance

#!/bin/bash

# specify paths:
bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed

# load pyfMRIqc:
module load anaconda3-2021.05/pyfMRIqc

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

        # go to pyfMRIqc directory:
        cd /usr/share/pyfMRIqc/

        # run pyfMRIqc:
        echo "Running pyfMRIqc checks for ${i} ${ses}."
            python pyfMRIqc/pyfMRIqc.py -n ${bids_path}/${i}/${ses}/func/${i}_${ses}_task-rest_bold.nii.gz -t 200 -s 5 -m ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/mc/prefiltered_func_data_mcf.par
                    # the input parameters are:
                    #-- functional file (.nii.gz file)
                    #-- threshold value (-t of 200 is used as default)
                    #-- SNR threshold (-s of 5 is used as default)
                    #-- motion-corrected file from FSL (.par file)
                    
        echo "pyfMRIqc checks for ${i} ${ses} complete."
        
    done
    
done

