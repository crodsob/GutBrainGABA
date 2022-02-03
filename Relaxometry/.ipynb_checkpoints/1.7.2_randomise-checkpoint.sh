#Carolyn McNabb 
#February 2022
#GBGABA STUDY ANALYSIS 
#1.7.2_randomise.sh run randomise on the MP2RAGE data

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
output_path=${bids_path}/derivatives/relaxometry/analysis
design=otus #change this to match the GLM you want to run through randomise
permutations=500 # change this to the number of permuations you want to run - recommended number for final analysis is 5000

echo "Running Randomise on ${design} GLM using ${permutations} permutations"

#The -D option tells randomise to demean the data before continuing - this is necessary if you are not modelling the mean in the design matrix. The -T option tells randomise that the test statistic that you wish to use is TFCE (threshold-free cluster enhancement)

randomise -i ${output_path}/GBGABA_MNI_T1s.nii.gz -o ${output_path}/T1_randomise -d ${output_path}/GLMs/${design}.mat -t ${output_path}/GLMs/${design}.con -n ${permutations} -D -T