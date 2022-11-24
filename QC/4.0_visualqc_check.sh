# Claudia Rodriguez-Sobstel
# November 2022

# GBGABA BRAIN DATA ANALYSIS
# 4.0_visualqc_check.sh utilises visualqc software to open and inspect T1 scans for quality.
# see https://raamana.github.io/visualqc/cli_t1_mri.html for guidance.

#!/bin/bash

# use visualqc to check the T1w image quality:
visualqc_anatomical --bids_dir=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS --out_dir /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/anat/T1w  --id_list /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/qc_sub_list.txt --mri_name 'ses-01/anat/sub*_T1w.nii.gz' --num_slices 18

# input parameters:
# --id_list: adds path to file containing list of subject IDs to be processed. If not provided, all the subjects with required files will be processed.
# --bids_dir: absolute path to the top-level BIDS folder containing the dataset. Each subject will be named after the longest/unique ID encoding info on sessions and anything else available in the filename in the deepest hierarchy etc.
# --out_dir: output folder to store the visualizations & ratings. Default: a new folder called visualqc will be created inside the input folder.
# --mri_name: specifies the name of MRI image to serve as the reference slice. Typical options include orig.mgz, brainmask.mgz, T1.mgz etc. Make sure to choose the right vis_type.
# --num_slices: specifies the number of slices to display per each view. This must be even to facilitate better division. Default: 12.
