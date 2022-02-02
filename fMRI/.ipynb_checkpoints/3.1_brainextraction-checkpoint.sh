#Carolyn McNabb 
#August 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.1_brainextraction.sh reorients structural data to normal fsl space then runs brain extraction. Output is stored in derivatives/fMRI/preprocessed/ppt/anat folder for each ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}
    
        echo "Making anat directory for ${i}_${ses}"
        mkdir -p ${derivative_path}/${i}/${ses}/anat
     
        echo "Reorienting struct data for ${i}_${ses} to fsl space"
        fslreorient2std ${bids_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz

        echo "Running brain extraction for ${i}_${ses}"
        bet ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w_brain
    
        echo "Opening brain extracted image (${i}_${ses}) for user approval"
        fsleyes ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w_brain --cmap red-yellow &
    
        read -p "Are you happy with the brain extraction for ${i}_${ses}? (Y/N): " userinput
        echo "Brain extraction for ${i}_${ses} okay?: ${userinput}" >> ${derivative_path}/brain_extraction_checks.txt

    done
done