#Carolyn McNabb 
#November 2021
#GBGABA BRAIN DATA PILOT ANALYSIS 
#3.9_randomise.sh will use FSL's randomise function to run nonparametric permutation tests on the dual regression output using the GLM files available in the GLMs directory (created using FSL's Glm tool). This will use the dual regression stage 2 files within a dual regression directory to produce F test results for each independent component
#F-test alpha values should be determined using some kind of correction for multiple comparisons (i.e. FDR or bonferroni) using only the ICs you are interested in.
#adapt numbers below to include all ICs

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#define paths
bids_path=/storage/shared/research/cinn/2020/gbgaba/pilot_BIDS
derivative_path=${bids_path}/derivatives/fMRI/preprocessed
analysis_path=${bids_path}/derivatives/fMRI/analysis
script_path=/storage/shared/research/cinn/2020/gbgaba/scripts
GLM_path=${script_path}/GLMs


#Define variables
dim=30 #how many ICs do you have? This includes any that are noise.
glm=ICA_LCMS_Ftest #what GLM are you evaluating?
WP=WP1 #which workpackage are you running analysis for?


read -p "Number of independent components is ${dim}. Is this okay? (Y/N): " userinput
       
if [ ${userinput} == "Y" ] || [ ${userinput} == "y" ]; then

    ics="$((dim-1))" #melodic counts components from 0 so this will remove one value from the dim variable
    for ic in $( seq 00 ${ics} ) ; do
        i=$(echo `printf "%02d\n" $ic`) #melodic uses two significant figures to count ICs so this will add a 0 to values < 10 - note that if you have more than 100 ICs, you'll need to add another 0 to this function and modify the code below - although I wouldn't think you'd want to evaluate that many ICs (too many corrections for multiple comparisons)
    
        echo "Performing randomise on IC${i}"
        randomise -i ${analysis_path}/dual_regression_${WP}.DR/dr_stage2_ic00${i}.nii.gz -o ${analysis_path}/dual_regression_${WP}.DR/randomise_ftest_ic${i} -d ${GLM_path}/${glm}.mat -t ${GLM_path}/${glm}.con -f ${GLM_path}/${glm}.fts -n 5000 -D -T -x
    done

else
    echo "Go back and define the number of components in the script 3.9_randomise.sh"

fi


#save output from randomise into inferential stats txt file
#the ?s act as wildcards; ?? refers to the number of the component and ? refers to the contrast you are asking about:
for i in ${analysis_path}/dual_regression_${WP}.DR/randomise_ftest_ic??_tfce_corrp_fstat?.nii.gz ; do
    echo ${i} `fslstats ${i} -R` >> ${analysis_path}/inferential_stats_ftests_${WP}.txt
done
