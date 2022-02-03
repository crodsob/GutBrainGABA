#Carolyn McNabb 
#November 2021
#GBGABA STUDY ANALYSIS 
#3.6_smoothdownsample.sh will smooth the standardised fmri resting state data using a Gaussian kernel and FWHM 5 mm and then downsample to a 2 mm voxel size so that melodic runs quicker.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.


bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed
script_path=/storage/shared/research/cinn/2020/gbgaba/scripts



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
                           
            echo "Smoothing standardised filtered func data for ${i} ${ses}"
            
            #-s <sigma> : creates a gauss kernel of sigma mm and performs mean filtering           
           fslmaths ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard.nii.gz -s 2.1233226 ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth.nii.gz
           
            echo "Downsampling smoothed standardised filtered func data for ${i} ${ses}"
          
            flirt -interp nearestneighbour -in ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth.nii.gz -ref ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/reg/standard.nii.gz -applyisoxfm 2 -out ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth_2mm.nii.gz
            
            
            #We need the melodic paths to be printed to different txt files depending on whether the ppt is part of (workpackage 1) WP1 or (workpackage 2) WP2. 
            if [ ${ses} = "ses-01" ]; then 
                echo "Printing path to melodic_inputlist_WP1"
                echo "${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth_2mm.nii.gz" >> ${script_path}/melodic_inputlist_WP1.txt
            
            elif [ ${ses} != "ses-01" ]; then 
                echo "Printing path to melodic_inputlist_WP2"
                echo "${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth_2mm.nii.gz" >> ${script_path}/melodic_inputlist_WP2.txt
            
            fi
            
            #All WP2 ppts are also part of WP1 so their ses-01 data needs to be in both txt files (melodic_inputlist_WP1.txt and melodic_inputlist_WP2.txt)
            if [ ${ses} = "ses-01" ] && [ ${#sessions[@]} > 1 ]; then 
            echo "Printing path to melodic_inputlist_WP2"
                echo "${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth_2mm.nii.gz" >> ${script_path}/melodic_inputlist_WP2.txt
            fi
    
            echo "Deleting ${i}_${ses}_filtered_func_standard.nii.gz & ${i}_${ses}_filtered_func_standard_smooth.nii.gz"
            rm ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard.nii.gz
            rm ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/${i}_${ses}_filtered_func_standard_smooth.nii.gz
                
        else
           
           echo "No clean fMRI data available for ${i} ${ses}"
                   
        fi
    done
done

