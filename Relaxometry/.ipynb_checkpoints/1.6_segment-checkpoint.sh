#Carolyn McNabb 
#December 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#1.6_segment.sh will segment the warped group_template image (in MNI space) into different tissue types (Grey Matter, White Matter, CSF, etc.) so that it can be used to mask the white matter during Randomise. This script uses FSL's FAST for tissue segmentation and an a-priori tissue map in MNI space to initialise the segmentation.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#Set up paths
bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
template_path=${derivative_path}/template
mni_path=/storage/shared/research/cinn/2020/gbgaba/standard

