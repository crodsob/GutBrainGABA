#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.4.3_fix_stage3.sh will run the third stage of FSL's FIX for those subjects with resting-state fMRI data. Make sure you define the threshold before running!
#!/bin/bash


bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed


#DEFINE THRESHOLD FOR FIX
thres=20 #change this to an appropriate threshold based on the output from the FIX classifier


#Make sure threshold has been defined before continuing

read -p "HAVE YOU DEFINED THE THRESHOLD FOR FIX? (Y/N): " userinput
       
if [ ${userinput} == "Y" ] || [ ${userinput} == "y" ]; then

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
        
                echo "Running FIX stage 3 for ${i} ${ses}"         
            
                fix -a ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/fix4melview_FIXtask_thr${thres}.txt -m
            
            else
                echo "Resting state fMRI data do not exist for ${i} ${ses}"
            fi
        done
    done

else
    echo "Go back and define the threshold in the script 3.4.3_fix_stage3.sh"

fi
