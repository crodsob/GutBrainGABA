# Claudia Rodriguez-Sobstel
# November 2022
# Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA

# GBGABA BRAIN DATA ANALYSIS
# 2.0_mv_files.sh will copy the MRS files from the MRS_raw participant folder to their MRS folder in the pilot_BIDS directory. You need to run this AFTER you have done your dcm2bids conversion.

#!/bin/bash

# specify paths:
    # comment this out if Shan was NOT there to OP/store the data:
rawMRS_path=/storage/shared/research/cinn/2020/gbgaba/MRS_raw
    # comment this out if Shan WAS there to OP/store the data:
# rawMRS_path=/storage/shared/research/cinn/2020/gbgaba
bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS

cd $bids_path

#---- for individual pre-processing (comment this section out for group pre-processing):

# obtain user input:
read -p "Participant ID (as recorded in MRS_raw folder, e.g. GBGABA_W1002s1): " raw_ppt_ID
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

        # specify MRS path:
        mrs_path=${bids_path}/${i}/${ses}/mrs

        # make mrs directory within subject session directory:
        mkdir -p ${mrs_path}/motorcortex/mega-press
        mkdir -p ${mrs_path}/motorcortex/mega-press_ref
        mkdir -p ${mrs_path}/motorcortex/water
        mkdir -p ${mrs_path}/occipital/mega-press
        mkdir -p ${mrs_path}/occipital/mega-press_ref
        mkdir -p ${mrs_path}/occipital/water

        # now copy the file to the directory and re-name as follows:
        find ${rawMRS_path}/${raw_ppt_ID}/*SAT_MC* -exec cp '{}' ${mrs_path}/motorcortex/mega-press/${i}_${ses}_mega-press.dat \;
        find ${rawMRS_path}/${raw_ppt_ID}/*H2O_MC* -exec cp '{}' ${mrs_path}/motorcortex/mega-press_ref/${i}_${ses}_mega-press_ref.dat \;
        find ${rawMRS_path}/${raw_ppt_ID}/*MC_H2O* -exec cp '{}' ${mrs_path}/motorcortex/water/${i}_${ses}_water.dat  \;


        find ${rawMRS_path}/${raw_ppt_ID}/*OCC_SAT* -exec cp '{}' ${mrs_path}/occipital/mega-press/${i}_${ses}_mega-press.dat \;
        find ${rawMRS_path}/${raw_ppt_ID}/*H2O_OCC* -exec cp '{}' ${mrs_path}/occipital/mega-press_ref/${i}_${ses}_mega-press_ref.dat \;
        find ${rawMRS_path}/${raw_ppt_ID}/*OCC_H2O* -exec cp '{}' ${mrs_path}/occipital/water/${i}_${ses}_water.dat \;

        echo "MRS files for ${i}${ses} moved to BIDS folder."
        
    done
    
done
