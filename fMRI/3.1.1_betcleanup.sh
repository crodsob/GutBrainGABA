#Carolyn McNabb 
#August 2021
#GBGABA STUDY ANALYSIS 
#3.1.1_betcleanup.sh performs brain extraction using centre of gravity coordinates 
#for those ppts who were previously identified to have poor brain extraction in 3.1_brainextraction.sh.
#Note that subjects have been entered manually into this script (line 18)
#Output is stored in derivatives/fMRI/preprocessed folder for each ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed

cd $bids_path

    for sub in 005 017; do 
    i=$(echo "sub-${sub}")
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}
    
        echo "deleting old brain extraction files"
        rm ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w_brain*
    
        echo "Identify [x y z] coordinates of centre of gravity for ${i}"
        fsleyes ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz
    
        read -p "[x] coordinate: " xinput
        read -p "[y] coordinate: " yinput
        read -p "[z] coordinate: " zinput
    
        bet ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w_brain -c ${xinput} ${yinput} ${zinput}
    
        echo "Opening brain extracted image (${i}_${ses}) for user approval"
        fsleyes ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w.nii.gz ${derivative_path}/${i}/${ses}/anat/${i}_${ses}_T1w_brain --cmap red-yellow &
    
        read -p "Are you happy with the brain extraction for ${i}_${ses}? (Y/N): " userinput
        echo "Cleanup for ${i}_${ses} okay?: ${userinput}" >> ${derivative_path}/secondbet_checks.txt
    
    done
done