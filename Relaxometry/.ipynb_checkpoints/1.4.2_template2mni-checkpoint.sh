#Carolyn McNabb 
#December 2021
#GBGABA STUDY ANALYSIS 
#1.4.2_template2mni.sh will use antsRegistrationSyN.sh to register the group template to MNI space
#!/bin/bash

module load ANTs/ITKv4 #load ANTs - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
template_path=${derivative_path}/template
mni_path=/storage/shared/research/cinn/2020/gbgaba/standard

#set up variables
dim=3 #image dimensions


cd ${template_path}

antsRegistrationSyN.sh -d ${dim} -m ${template_path}/group_template_template0.nii.gz -f ${mni_path}/MNI152_T1_1mm_brain.nii.gz -i ${template_path}/initial_matrix.txt -o ${template_path}/group_template_in_MNI 
