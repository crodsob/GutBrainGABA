#Carolyn McNabb 
#November 2021
#GBGABA STUDY ANALYSIS 
#1.2_hd_bet.sh will run brain extraction on MP2_UNI image (output from QUIT) so it can be used to mask the T1 and UNI images 
#Uses HD-BET, available from https://github.com/MIC-DKFZ/HD-BET

#!/bin/bash


bids_path=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS
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

        if [ -e ${derivative_path}/${i}/${ses}/MP2_UNI.nii.gz ]; then
        
            echo "Masking UNI image for ${i} ${ses}"
        
            hd-bet -i ${derivative_path}/${i}/${ses}/MP2_UNI.nii.gz -o ${derivative_path}/${i}/${ses}/${i}_${ses} -device cpu -mode fast -tta 0
        else
            echo "MP2_UNI file does not exist for ${i} ${ses}"
        fi
    done
done