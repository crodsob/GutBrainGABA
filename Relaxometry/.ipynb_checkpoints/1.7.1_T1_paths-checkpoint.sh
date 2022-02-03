#Carolyn McNabb 
#February 2022
#GBGABA STUDY ANALYSIS 
#1.7.1_T1_paths.sh will produce a file containing all the T1 files in MNI space. This file can then be used in the Randomise step.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
output_path=${bids_path}/derivatives/relaxometry/analysis

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}
    
        if [ -e ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain_MNI.nii.gz ]; then

            echo ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain_MNI.nii.gz >> ${output_path}/GBGABA_MNI_T1s.txt
        else
            echo "MP2_T1_brain_MNI file does not exist for ${i} ${ses}"
        fi
    done
done


# Merge the files together to create one single nifti file
fslmerge -t ${output_path}/GBGABA_MNI_T1s.nii.gz `cat ${output_path}/GBGABA_MNI_T1s.txt`