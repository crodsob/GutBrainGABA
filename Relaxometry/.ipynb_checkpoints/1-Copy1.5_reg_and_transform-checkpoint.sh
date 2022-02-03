#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#1.5_reg_and_transform.sh will register subject T1 images to the group template image and then apply transformations to warp the subject T1 data into MNI space
#!/bin/bash


bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
template_path=${derivative_path}/template
mni_path=/storage/shared/research/cinn/2020/gbgaba/standard

#set up variables
dim=3 #image dimensions



cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}

        if [ -e ${derivative_path}/${i}/${ses}/MP2_T1_brain.nii.gz ]; then
        
            echo "Registering T1 image to group template for ${i} ${ses}"
        
#            antsRegistrationSyN.sh -d ${dim} -m ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain.nii.gz -f ${template_path}/group_template_template0.nii.gz -o ${derivative_path}/${i}/${ses}/${i}_${ses}_T1_to_group_template
            antsRegistrationSyN.sh -d ${dim} -m ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_UNI_brain.nii.gz -f ${template_path}/group_template_template0.nii.gz -o ${derivative_path}/${i}/${ses}/${i}_${ses}_UNI_to_group_template
            
            echo "Transforming T1 image to MNI space for ${i} ${ses}"
            
#            antsApplyTransforms -d ${dim} -i ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain.nii.gz -r ${mni_path}/MNI152_T1_1mm_brain.nii.gz -o ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_T1_brain_MNI.nii.gz -t ${template_path}/group_template_in_MNI1Warp.nii.gz -t ${template_path}/group_template_in_MNI0GenericAffine.mat -t ${derivative_path}/${i}/${ses}/${i}_${ses}_T1_to_group_template1Warp.nii.gz -t ${derivative_path}/${i}/${ses}/${i}_${ses}_T1_to_group_template0GenericAffine.mat  -v
            antsApplyTransforms -d ${dim} -i ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_UNI_brain.nii.gz -r ${mni_path}/MNI152_T1_1mm_brain.nii.gz -o ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_UNI_brain_MNI.nii.gz -t ${template_path}/group_template_in_MNI1Warp.nii.gz -t ${template_path}/group_template_in_MNI0GenericAffine.mat -t ${derivative_path}/${i}/${ses}/${i}_${ses}_UNI_to_group_template1Warp.nii.gz -t ${derivative_path}/${i}/${ses}/${i}_${ses}_UNI_to_group_template0GenericAffine.mat  -v
        else
            echo "MP2_T1_brain file does not exist for ${i} ${ses}"
        fi
    done
done