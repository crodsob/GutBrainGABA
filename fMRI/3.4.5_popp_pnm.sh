#Carolyn McNabb 
#February 2022
#GBGABA STUDY ANALYSIS 
#3.4.5_popp_pnm.sh takes creates regressors for cardiac and respiratory noise to use in ICA_PNM (next step). Before running this script, you must have created a clean physio file using 3.4.4_clean_physio.R

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
    cd ${bids_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}
    
        # run popp
        popp --tr=2.16 --cardiac=1 --resp=2 --trigger=3 --samplingrate=1000 -i ${derivative_path}/${i}/${ses}/func/${i}_${ses}_task-rest_physio_clean.txt -o ${derivative_path}/${i}/${ses}/func/${i}_${ses}
        
        # run pnm_env
        pnm_evs --slicetiming=/storage/shared/research/cinn/2020/gbgaba/scripts/slice_timing.txt --tr=2.16 -i ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/filtered_func_data.nii.gz  -o ${derivative_path}/${i}/${ses}/func/${i}_${ses}_pnmevs -c ${derivative_path}/${i}/${ses}/func/${i}_${ses}_card.txt -r ${derivative_path}/${i}/${ses}/func/${i}_${ses}_resp.txt

    done
done


# or for a single subject:
#popp --tr=2.16 --cardiac=1 --resp=2 --trigger=3 --samplingrate=1000 -i sub-W0001_ses-01_task-rest_physio_clean.txt -o sub-W0001_ses-01

#pnm_evs --slicetiming=/storage/shared/research/cinn/2020/gbgaba/scripts/slice_timing.txt --tr=2.16 -i sub-W0001_ses-01_FEATpreproc.feat/filtered_func_data.nii.gz  -o sub-W0001_ses-01_pnmevs -c sub-W0001_ses-01_card.txt -r sub-W0001_ses-01_resp.txt


