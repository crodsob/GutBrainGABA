#Carolyn McNabb 
#February 2022
#GBGABA BRAIN DATA ANALYSIS 
#2.0_mv_files.sh will copy the MRS files from the MRS_raw participant folder to their MRS folder in the GBGABA_BIDS directory. You need to run this AFTER you have done your dcm2bids conversion.

#!/bin/bash

#Get user input
read -p "Participant ID (as recorded in MRS_raw folder, e.g. GBGABA_W1001): " raw_ppt_ID
read -p "Paricipant ID (in BIDS format, with sub- in front, e.g., sub-W1001): " i
read -p "Session ID, with ses- in front, e.g., ses-01: " ses


rawMRS_path=/storage/shared/research/cinn/2020/gbgaba/MRS_raw
bids_path=/storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS
mrs_path=${bids_path}/${i}/${ses}/mrs

#make mrs directory within subject session directory
mkdir -p ${mrs_path}/motorcortex/mega-press
mkdir -p ${mrs_path}/motorcortex/mega-press_ref
mkdir -p ${mrs_path}/motorcortex/water
mkdir -p ${mrs_path}/occipital/mega-press
mkdir -p ${mrs_path}/occipital/mega-press_ref
mkdir -p ${mrs_path}/occipital/water

#now copy the file to the directory
find ${rawMRS_path}/${raw_ppt_ID}/*SAT_MC* -exec cp '{}' ${mrs_path}/motorcortex/mega-press/${i}_${ses}_mega-press.dat \;
find ${rawMRS_path}/${raw_ppt_ID}/*H2O_MC* -exec cp '{}' ${mrs_path}/motorcortex/mega-press_ref/${i}_${ses}_mega-press_ref.dat \;
find ${rawMRS_path}/${raw_ppt_ID}/*MC_H2O* -exec cp '{}' ${mrs_path}/motorcortex/water/${i}_${ses}_water.dat  \;


find ${rawMRS_path}/${raw_ppt_ID}/*OCC_SAT* -exec cp '{}' ${mrs_path}/occipital/mega-press/${i}_${ses}_mega-press.dat \;
find ${rawMRS_path}/${raw_ppt_ID}/*H2O_OCC* -exec cp '{}' ${mrs_path}/occipital/mega-press_ref/${i}_${ses}_mega-press_ref.dat \;
find ${rawMRS_path}/${raw_ppt_ID}/*OCC_H2O* -exec cp '{}' ${mrs_path}/occipital/water/${i}_${ses}_water.dat \;
