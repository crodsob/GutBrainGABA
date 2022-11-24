#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA ANALYSIS 
#1.4.0_mkdir_template.sh will copy the brain-extracted T1/UNI images from selected participants (which you need to define in the script below)
#!/bin/bash

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
template_path=${derivative_path}/template

mkdir -p ${template_path}

cd ${derivative_path}

for sub in 003 004 005 008; do #list the participants you want to include in the template here
    i=$(echo "sub-${sub}")
    
    cd ${derivative_path}/${i}

    for session in 01; do
        ses=$(echo "ses-${session}")
        
        #now copy the file to the template directory
        #cp ${derivative_path}/${i}/${ses}/${i}_${s}_MP2_T1_brain.nii.gz ${template_path}
        cp ${derivative_path}/${i}/${ses}/${i}_${ses}_MP2_UNI_brain.nii.gz ${template_path}

    done
done

### claudia note: figure out whether only need to copy T1 or UNI image? 
