#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.8_dualregression.sh runs FSL's dual regression using the group-level independent components created with MELODIC
#Usage: dual_regression <group_IC_maps> <des_norm> <design.mat> <design.con> <n_perm> <output_directory> <input1> <input2> <input3>

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#define paths
bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
analysis_path=${bids_path}/derivatives/fMRI/analysis
script_path=/storage/shared/research/cinn/2020/gbgaba/scripts
GLM_path=${script_path}/GLMs

#Number of permutations
perm=5000

echo "Running dual regression for GBGABA WP1 data"

dual_regression ${analysis_path}/melodic_components_WP1/melodic_IC.nii.gz 1 ${GLM_path}/ICA_LCMS.mat ${GLM_path}/ICA_LCMS.con ${perm} ${analysis_path}/dual_regression_WP1.DR `cat ${script_path}/melodic_inputlist_WP1.txt`

#save inferential statistics into a file within the analysis directory
#the ?s act as wildcards; ?? refers to the number of the component and ? refers to the contrast you are asking about:
for i in ${analysis_path}/dual_regression_WP1.DR/dr_stage3_ic00??_tfce_corrp_tstat?.nii.gz ; do
    echo ${i} `fslstats ${i} -R` >> ${analysis_path}/inferential_stats_ttests_WP1.txt
done
