#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.4.1_fix_stage1.sh will run the first stage of FSL's FIX for those subjects with resting-state fMRI data.
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
        
            echo "Running FIX stage 1 for ${i} ${ses}"
            
            fix -f ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/
        
        else
            echo "Resting state fMRI data do not exist for ${i} ${ses}"
        fi
    done
done