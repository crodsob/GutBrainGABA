#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.5_warp2std.sh warps filtered_func_data into standard space. Output is stored in derivatives/fMRI/preprocessed/ppt/ses/func folder for each ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.


bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed

cd ${derivative_path}
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${derivative_path}/${i}
    sessions=( $(ls -d ses-*))
    
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}

        if [ -d ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat ]; then
        
            echo "Warping filtered_func_data to standard space for ${i} ${ses}"
                   
            applywarp -r ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/reg/standard.nii.gz  -i ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_data.nii.gz -o ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard -w ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/reg/highres2standard_warp.nii.gz --premat=${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/reg/example_func2highres.mat             
        
        else
           
           echo "No clean fMRI data available for ${i} ${ses}"
                   
        fi
    done
done

