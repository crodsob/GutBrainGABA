#Carolyn McNabb 
#November 2021
#GBGABA STUDY ANALYSIS 
#1.4.1_construct_template.sh will use ANTs to create a group template of the T1 data from the MP2RAGE data specfied in 1.4.0_mkdir_template.sh
#!/bin/bash

module load ANTs/ITKv4 #load ANTs - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths

bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
derivative_path=${bids_path}/derivatives/relaxometry/preprocessed
template_path=${derivative_path}/template

#set up variables
dim=3 #image dimensions
stat=1 #image statistic 1=mean of normalised intensities
iter=30x50x20 #Max-iterations in each registration
trans=GR #transformation model used for nonlinear registration; GR = Greedy SyN
sim=CC #similarity metric CC=cross correlation, which is the best but not necessarily the fastest 
par=0 #parallel computing, 0=run serially; 5=SLURM
output=group_template_ #output name
input=./*.nii.gz #input files

cd ${template_path}

antsMultivariateTemplateConstruction.sh -d ${dim} -a ${stat} -m ${iter} -t ${trans} -s ${sim} -c ${par} -o ${output} ${input}

