#Carolyn McNabb 
#August 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.3_FEATpreproc.sh modifies the parent file FEATpreproc.fsf to create a subject specific preprocessing file and runs this through FEAT. Output is stored in derivatives/fMRI/preprocessed/sub/ses/func folder for each ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed
#create a directory to put the FEATpreproc files into
script_path=/storage/shared/research/cinn/2020/gbgaba/scripts

mkdir ${script_path}/FEATpreproc

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}
    
        cd ${derivative_path}/${i}
    sessions=( $(ls -d ses-*))
    for visit in ${!sessions[@]}; do
        ses=${sessions[$visit]}

        echo "Making func directory for ${i} ${ses}"
        mkdir ${derivative_path}/${i}/${ses}/func

        #get number of volumes for resting state scan - in case this differs between subjects
        vols=`fslinfo ${bids_path}/${i}/${ses}/func/${i}_${ses}_task-rest_bold.nii.gz | grep "^dim4" | awk '{print $2}'`
        echo "Number of volumes for ${i} ${ses} is ${vols}"

        echo "Modifying FEATpreproc.fsf file and saving in ${script_path}/FEATpreproc directory"
        sed -e "s/sub-ID/${i}/g" -e "s/num_vols/${vols}/g" -e "s/ses-ID/${ses}/g" <${script_path}/FEATpreproc.fsf >${script_path}/FEATpreproc/${i}_${ses}_FEATpreproc.fsf

        echo "Running feat for ${i} ${ses}"
        feat ${script_path}/FEATpreproc/${i}_${ses}_FEATpreproc.fsf
    
    done
done