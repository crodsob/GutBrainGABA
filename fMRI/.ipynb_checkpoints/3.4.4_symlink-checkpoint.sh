#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.4.4_symlink.sh will rename the old filtered_func_data file so that a new symbolic link with this name can be created - pointing to the fixed filtered_func_data_clean.nii.gz file

#!/bin/bash


bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed



cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${derivative_path}/${i}
    sessions=( $(ls -d ses-*))
    
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}

        if [ -d ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat ]; then
        
            echo "Renaming original filtered_func_data file for ${i} ${ses}"
                   
            mv ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_data.nii.gz ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_pre_fix.nii.gz 
            
            echo "Creating symbolic link to clean (FIXed) data for ${i} ${ses}"
            ln -s ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_data_clean.nii.gz ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_data.nii.gz
        
        else
            echo "Renaming original filtered_func_data file for ${i} ${ses}"
                   
            mv ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_data.nii.gz ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_pre_fix.nii.gz 
            
            echo "Note - there are no clean data for ${i} ${ses}"

        fi
    done
done

