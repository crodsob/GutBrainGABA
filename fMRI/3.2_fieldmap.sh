#Carolyn McNabb 
#August 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.2_fieldmap.sh creates a fieldmap for each ppt and stores in derivatives/fMRI/preprocessed/ppt/fmap folder for that ppt.

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

        echo "Making fmap directory for ${i}"
        mkdir ${derivative_path}/${i}/${ses}/fmap
    
        echo "Performing brain extraction on magnitude1 image for ${i}_${ses}"
        bet ${bids_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1.nii.gz ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1_brain.nii.gz
    
        echo "Eroding brain extracted magnitude1 image"
        fslmaths ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1_brain.nii.gz -ero ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1_brain.nii.gz
    
        echo "Copying original magnitude1 image to derivatives folder"
        cp  ${bids_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1.nii.gz ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1.nii.gz
    
        echo "Make sure the magnitude1_brain image does not contain any non-brain!!! Erase any voxels as needed and overwrite the file."
        fsleyes ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1.nii.gz ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1_brain.nii.gz --cmap red-yellow
    

        read -p "Are you happy with the brain extraction for ${i}_${ses}? (Y/N): " userinput
        echo "Is the brain extraction of magnitude image for ${i}_${ses} okay?: ${userinput}" >> ${derivative_path}/magnitude_image_checks.txt

        if [ ${userinput} == "Y" ] || [ ${userinput} == "y" ]; then
            echo "creating fmap for ${i}_${ses}" 
            fsl_prepare_fieldmap SIEMENS ${bids_path}/${i}/${ses}/fmap/${i}_${ses}_phasediff.nii.gz ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_magnitude1_brain.nii.gz ${derivative_path}/${i}/${ses}/fmap/${i}_${ses}_fieldmap.nii.gz 2.46
            else
            echo "Because you weren't happy with the magnitude brain extraction for ${i}/${ses}, no fieldmap has been created."
            echo "Because you weren't happy with the magnitude brain extraction for ${i}/${ses}, no fieldmap has been created." >> ${derivative_path}/magnitude_image_checks.txt
        fi

    done
done