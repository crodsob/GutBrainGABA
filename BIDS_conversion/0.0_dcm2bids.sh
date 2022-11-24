# Claudia Rodriguez-Sobstel
# November 2022

# GBGABA BRAIN DATA ANALYSIS
# 0.0_dcm2bids.sh will convert raw data to BIDS format

#!/bin/bash

# clear any open firefox applications:
rm -r ~/.mozilla

# load anaconda module:
module load anaconda

# add path to anaconda module:
PATH=$PATH:/opt/anaconda/bin/
export PATH

# specify paths:
bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
raw_path=/storage/shared/research/cinn/2020/gbgaba/raw
json_path=/storage/shared/research/cinn/2020/gbgaba/scripts_claudia/code
conda_path=/storage/shared/research/cinn/2020/gbgaba/scripts_claudia/conda_env

# activate the conda environment:
source activate ${conda_path}

# go to bids directory:
cd ${bids_path}

# test dcm2bids is working:
dcm2bids --help

# obtain user input (for individual pre-processing purposes),
# to specify participant ID and session number:
read -p "Participant ID (as recorded in MRS_raw folder, e.g. GBGABA_W2AB038S1):" raw_ppt_ID
read -p "Paricipant ID (WITHOUT sub- in front, e.g., W1002): " i
read -p "Session ID, WITHOUT ses- in front, e.g., 01: " ses

# run dcm2bids:
dcm2bids -d ${raw_path}/${raw_ppt_ID} -p ${i} -s ${ses} -c ${json_path}/dcm2bids_config.json

echo "dcm2bids for ${i}${ses} complete"
