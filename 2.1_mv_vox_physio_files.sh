# Claudia Rodriguez-Sobstel
# November 2022

# GBGABA BRAIN DATA ANALYSIS
# 2.1_mv_vox_physio_files.sh will copy the voxel placement files onto OneDrive, and the physio files into the ppts BIDS directory.

#!/bin/bash

# specify paths:
    # comment this out if Shan was NOT there to OP/store the data:
rawMRS_path=/Volumes/gold/cinn/2020/gbgaba/MRS_raw
    # comment this out if Shan WAS there to OP/store the data:
# rawMRS_path=/Volumes/gold/cinn/2020/gbgaba/
voxel_placement_path="/Users/bhismalab/Library/CloudStorage/OneDrive-SharedLibraries-UniversityofReading/Bhismadev Chakrabarti - GutBrainGABA/study/data/MRI_supplements/voxel_placements"
physio_path="/Users/bhismalab/Library/CloudStorage/OneDrive-SharedLibraries-UniversityofReading/Bhismadev Chakrabarti - GutBrainGABA/study/data/MRI_supplements/physio"
bids_path=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS
# note to self: the physio and voxel placement directories don't seem to work

#---- for individual pre-processing (comment this section out for group pre-processing):

# obtain user input (for individual pre-processing purposes),
# to specify participant ID and session number:
read -p "Participant ID (as recorded in MRS_raw folder, e.g. GBGABA_W2AB038S1):" raw_ppt_ID
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

        # copy voxel placement screenshots into their directories:
        echo "Copying MC voxel placement screenshots to OneDrive for ${i}${ses}"
            cp ${rawMRS_path}/${raw_ppt_ID}/*mc* /Users/bhismalab/Library/CloudStorage/OneDrive-SharedLibraries-UniversityofReading/Bhismadev\ Chakrabarti\ -\ GutBrainGABA/study/data/MRI_supplements/voxel_placements/${i}_${ses}_mc_voxel.png

        echo "MC voxel placement screenshots copied to OneDrive for ${i}${ses}"

        echo "Copying OCC voxel placement screenshots to OneDrive for ${i}${ses}"
            cp ${rawMRS_path}/${raw_ppt_ID}/*occ* /Users/bhismalab/Library/CloudStorage/OneDrive-SharedLibraries-UniversityofReading/Bhismadev\ Chakrabarti\ -\ GutBrainGABA/study/data/MRI_supplements/voxel_placements/${i}_${ses}_occ_voxel.png

        echo "OCC voxel placement copied to OneDrive for ${i}${ses}"

        # copy physio files into their directories:
        echo "Copying physio .adicht file into func directory for ${i}${ses}"
            cp /Users/bhismalab/Library/CloudStorage/OneDrive-SharedLibraries-UniversityofReading/Bhismadev\ Chakrabarti\ -\ GutBrainGABA/study/data/MRI_supplements/physio/${i}_${ses}_task-rest_physio.adicht ${bids_path}/${i}/${ses}/func/

        echo "Physio .adicht file copied func directory for ${i}${ses}"

        echo "Copying physio .txt file into func directory for ${i}${ses}"
         cp /Users/bhismalab/Library/CloudStorage/OneDrive-SharedLibraries-UniversityofReading/Bhismadev\ Chakrabarti\ -\ GutBrainGABA/study/data/MRI_supplements/physio/${i}_${ses}_task-rest_physio.txt ${bids_path}/${i}/${ses}/func/

        echo "Physio .txt file copied into func directory for ${i}${ses}"
        
    done
    
done
