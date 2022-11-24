#Carolyn McNabb 
#November 2021
#GBGABA STUDY ANALYSIS 
#1.3_mask_t1.sh will mask the t1 and UNI images (output from quit) using the mask created by HD-BET
#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed

cd $bids_path
#subjects=( $(ls -d sub-* ))

#for sub in ${!subjects[@]}; do
for sub in sub-W1016 sub-W1022; do
    i=$sub
    #i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}
    
        if [ -e ${derivative_path}/${i}/${ses}/MP2_T1.nii.gz ]; then

            echo "Masking t1 and UNI images for ${i} ${ses} - outputs are ${i}_${ses}_MP2_T1_brain.nii.gz and ${i}_${ses}_MP2_UNI_brain.nii.gz "
        
            fslmaths ${derivative_path}/${i}/${ses}/MP2_T1.nii.gz -mul ${derivative_path}/${i}/${ses}/${i}_${ses}_mask.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain.nii.gz
        
            fslmaths ${derivative_path}/${i}/${ses}/MP2_UNI.nii.gz -mul ${derivative_path}/${i}/${ses}/${i}_${ses}_mask.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_UNI_brain.nii.gz
        else
            echo "MP2_T1 file does not exist for ${i} ${ses}"
        fi
    done
done
