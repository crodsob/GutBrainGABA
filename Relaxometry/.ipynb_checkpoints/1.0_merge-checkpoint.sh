#Carolyn McNabb 
#September 2021
#GBGABA study ANALYSIS 
#1.0_merge.sh will merge magnitude and phase images acquired using MP2RAGE
#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}

    
        if [ -e ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_magnitude_mp2rage.nii.gz ]; then
            
            
            echo "Making derivative directory for ${i}_${ses}"
            mkdir -p ${derivative_path}/${i}/${ses}/
 
            echo "Merging magnitude files for ${i} ${ses}"
        
            fslmerge -t ${derivative_path}/${i}/${ses}/${i}_${ses}_mag ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_magnitude_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI2_magnitude_mp2rage.nii.gz
            
            echo "Reorienting mag file for ${i} ${ses}"
            #reorient the mag image to standard orientation using FSL
            #this is to avoid any issues down the line when creating the group template
            fslreorient2std ${derivative_path}/${i}/${ses}/${i}_${ses}_mag.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_mag.nii.gz
                         
            echo "Merging phase files for ${i} ${ses}"
        
            fslmerge -t ${derivative_path}/${i}/${ses}/${i}_${ses}_phase ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI1_phase_mp2rage.nii.gz ${bids_path}/${i}/${ses}/anat/${i}_${ses}_TI2_phase_mp2rage.nii.gz

            echo "Converting phase images to radians for ${i} ${ses}"
        
            fslmaths ${derivative_path}/${i}/${ses}/${i}_${ses}_phase -div 4096 -mul 3.141592653 ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad
            
            echo "Reorienting phase_rad file for ${i} ${ses}"
            #reorient the mag image to standard orientation using FSL
            #this is to avoid any issues down the line when creating the group template
            fslreorient2std ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad.nii.gz ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad.nii.gz
                         
        else
            echo "No MP2RAGE data for ${i} ${ses}"
        fi
    done
done