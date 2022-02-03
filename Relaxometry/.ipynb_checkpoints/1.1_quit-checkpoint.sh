#Carolyn McNabb 
#October 2021
#GBGABA STUDY ANALYSIS 
#1.1_quit.sh will run quit commands to create complex data file and T1 image from MP2RAGE data
#!/bin/bash


bids_path=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
json_path=/Volumes/gold/cinn/2020/gbgaba/scripts/code

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}

 
        cd ${derivative_path}/${i}/${ses}
        
        echo "Creating complex image for ${i} ${ses}"
        
        qi complex -m ${derivative_path}/${i}/${ses}/${i}_${ses}_mag.nii.gz -p ${derivative_path}/${i}/${ses}/${i}_${ses}_phase_rad.nii.gz -X ${derivative_path}/${i}/${ses}/${i}_${ses}_mp2_x.nii
        
        
        echo "Creating T1 and UNI images for ${i} ${ses}"
        
        qi mp2rage ${derivative_path}/${i}/${ses}/${i}_${ses}_mp2_x.nii --json=${json_path}/mp2rage.json --beta=10000


    done
done