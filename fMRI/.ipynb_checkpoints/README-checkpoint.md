# GBGABA ANALYSIS for resting-state fMRI
Carolyn McNabb 2021 - Find me at https://github.com/CarolynMcNabb</br>
fMRI analysis uses FSL 6.0.1 on an ubuntu MATE 16.04 operating system (8GB).</br> 
All analysis scripts are available [here](https://github.com/CarolynMcNabb/GutBrainGABA/tree/main/fMRI)


The first time you run these scripts, whether on the virtual machine (VM) or on MacOS, you will need to make the scripts executable. To do this, run the following command in the terminal, replacing `script_name` with the relavant script name and `path_to_script` with the relevant path to the directory where your scripts are kept. Note that this is likely to be a different path for the VM and MacOS. You only have to do this **ONCE** for each script.
```
chmod u+x path_to_script/script_name
```

Every time you log onto a terminal, you need to remind it where your scripts are (or you can modify your bash profile). Once again, replace `path_to_script` with your actual path. In the terminal, type:
```
PATH=$PATH:path_to_script
export PATH
```

#### *N.B. All the paths in the scripts are specific to my own directories - the paths for the VM should be able to be used without adjusting but the MacOS paths will obviously need to be changed to match your own before continuing.* 
___

### 3.1 perform brain extraction of T1w scan for each participant using FSL's bet function. 
In the Ubuntu terminal, type:
```
3.1_brainextraction.sh
```
If brain extraction was unsuitable (you can check which subjects you were unhappy with in the brain_extraction_checks.txt file), you can run 3.1.1_betcleanup.sh to improve the extraction for those participants. Before running, you will need to open the script and edit the code to include only those subjects that need additional clean up (line 18). Once this is done, save the script and in the Ubuntu terminal, type:
```
3.1.1_betcleanup.sh
```

### 3.2. Create a B0 fieldmap for bias field correction during registration in FEAT. 
In the Ubuntu terminal, type:
```
3.2_fieldmap.sh
```

### 3.3. Run the first FEAT step (FEATpreproc) to produce independent components that will be used for motion correction. 
For this step, you need to have put the FEATpreproc.fsf file in a folder that you can access and amend the path to that folder in the 3.3_FEATpreproc.sh script. After doing that, in the Ubuntu terminal, type:
```
3.3_FEATpreproc.sh
```
#### CHECK FEAT OUTPUT BEFORE PROCEEDING – 
```
firefox /storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/fMRI/preprocessed/sub-W1008/ses-01/func/sub-W1008_ses-01_FEATpreproc.feat/report.html
```
##### Exclude any participant whose motion parameters excede:
Absolute motion >1.5 mm<br/>
Root mean square relative motion > 0.2 mm


##### Also assess whether registration is acceptable - if it is terrible, try going back to struct_brain and removing any non-brain that is still included. If still terrible then exclude the participant.

For the first 10 participants, make a note of the melodic components that are noise and create a text document for each participant called `hand_labels_noise.txt` in the feat directory. It should be a single line like this [1, 3, 5, 8, 9] – counting starts at one not zero (note that the square brackets, and use of commas, is required). Classification of noisey components can be done in fsleyes using the command below to view…

```
cd /storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/fMRI/preprocessed/sub-W1008/ses-01/func/sub-W1008_ses-01_FEATpreproc.feat/
fsleyes --scene melodic -ad filtered_func_data.ica &
```
*If you need some help classifying components, check out this paper by [Griffanti et al., 2017](https://www.sciencedirect.com/science/article/pii/S1053811916307583)*

### 3.4. Perform additional motion correction with FIX ([FSL’s ICA-based noise removal](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX))

When using FIX, you first need to update the path to the Matlab folder in your bash profile so that FIX can find it.
 
In the terminal, type:
```
gedit ~/.bash_profile
```
In your bash profile add a line:
``` 
export FSL_FIX_MATLAB_ROOT="/usr/local/MATLAB/R2017b"
```
Save your bash profile
 
Open a new terminal and type:
``` 
module load fix1.065
``` 

Once you have created `hand_labels_noise.txt` for ten participants, you can train the fix classifier and create the `fixtraining.rdata` file. The `–l` option runs a leave-one-out cross validation so you can check the accuracy of your model. Assuming you are using the first 10 participants in the cohort to train your model, type the following in the Ubuntu terminal (changing the path obviously):
```
cd /storage/shared/research/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/fMRI/preprocessed

fix –t ./FIX –l ./sub-W1001/ses-01/func/sub-W1001_ses-01_FEATpreproc.feat/ ./sub-W1002/ses-01/func/sub-W1002_ses-01_FEATpreproc.feat/ ./sub-W1003/ses-01/func/sub-W1003_ses-01_FEATpreproc.feat/ ./sub-W1004/ses-01/func/sub-W1004_ses-01_FEATpreproc.feat/ ./sub-W1005/ses-01/func/sub-W1005_ses-01_FEATpreproc.feat/ ./sub-W1006/ses-01/func/sub-W1006_ses-01_FEATpreproc.feat/ ./sub-W1007/ses-01/func/sub-W1007_ses-01_FEATpreproc.feat/ ./sub-W1008/ses-01/func/sub-W1008_ses-01_FEATpreproc.feat/ ./sub-W1009/ses-01/func/sub-W1009_ses-01_FEATpreproc.feat/ ./sub-W1010/ses-01/func/sub-W1010_ses-01_FEATpreproc.feat/
```

FIX classifier output will look like this:
<table>
  <tr>
      <td>
output: set of thresholds is: 1   2   5  10  20  30  40  50<br/>
[TPR,TNR,(3*TPR+TNR)/4] pairs of results (averaged over datasets, one pair per threshold):

mean<br/>
97.6 97.2 97.2 96.9 95.9 95.2 93.4 92.6<br/>
57.9 62.7 71.5 79.7 89.9 94.6 96.8 97.9<br/>
87.6 88.6 90.8 92.6 94.4 95.0 94.2 94.0<br/>

median<br/>
100.0 100.0 100.0 100.0  98.2  96.2  95.9  92.9<br/>
63.2 70.9 79.4 84.7 92.4 95.5 97.2 98.4<br/>
89.4 90.2 92.0 94.2 95.4 95.9 95.8 94.3<br/>
    </td>
   </tr>
</table>

You will need to select the best threshold based on the selectivity and specificity defined in the table. For the above example, a threshold of 30 gives the best accuracy

Now prepare all subject folders for FIX, using the following command:
```
3.4.1_fix_stage1.sh
```

Subject data are now ready for cleaning. From the FIX classifier output (mentioned above), select an appropriate threshold and edit the following script before running
```
3.4.2_fix_stage2.sh
```
---

**ONLY PERFORM THE NEXT STEP (`3.4.3`) IF YOU ARE ONLY USING FIX AND NOT USING THE PULSE AND RESPIRATORY DATA TO CLEAN YOUR DATA, OTHERWISE, SKIP PAST THIS TO `3.4.4`.**

Now run third FIX stage - you also need to edit this script with the new threshold before continuing.
```
3.4.3_fix_stage3.sh
```
IF YOU HAVE CHOSEN THIS PATH, YOU CAN NOW SKIP TO `3.4.6`

***

## Incorporating output from FIX and physiological recordings using PNM and fsl_ents
*Note that this section is untested and will likely need some modification to get it working on the actual data*</br>

Using the `fix4melview_thr.txt` file from the FIX output, you must first create a txt file containing only the noise components, separated by spaces. You can do this using [fsl_ents](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/ICA_PNM). Writing this into a script would look something like this:
```
fsl_ents ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat.feat/filtered_func_data.ica -o ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat.feat/${i}_${ses}_ICA_noise.txt ${derivative_path}/${i}/${ses}/func/${i}_${ses}_FEATpreproc.feat/fix4melview_FIX_thr30.txt
```

You also need to run [PNM](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PNM/UserGuide), which can model the effects of physiological noise in functional MRI data. Before running PNM, you need to clean the physiological data you get from LabChart7. This can be done in R using the following script: 
```
3.4.4_cleanphysio.R
```

To run PNM, you can either use the GUI in FSL or you can run the following script:
```
3.4.5_popp_pnm.sh
```

If you have carried out both PNM and FIX you should now have 2 text files (e.g., `sub-W1001_ses-01_pnmevs ` and `sub-W1001_ses-01_ICA_noise.txt`)  which should be input into the Voxel Confound List in FEAT.
Check [here](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/ICA_PNM) for guidance on how to do the next step.

**Note that the output file for the FEAT analysis at this stage should be named `filtered_func_data_clean`.**

***

Because the next steps will look for (and use) the filtered_func_data, the following script will create a symbolic link to the filtered_func_data_clean file and rename the original filtered_func_data as filtered_func_pre_fix. This step is really important so don't forget to do it!
```
3.4.6_symlink.sh
```

### 3.5. Warp functional data from subject space into standard space. 
In Ubuntu terminal window, type:
```
3.5_warp2std.sh
```

### 3.6. Smooth data and prepare GLM
Smooth the functional data (now in standard space) using a 5 mm Gausian kernel and then downsample to 2mm (currently in 1mm space) to increase speed of MELODIC. In ubuntu terminal, type:
```
3.6_smoothdownsample.sh
```

In addition, create a GLM containing the faecal GABA, Glutamate and Glutamine levels from LCMS. Note that you may want to change the way this GLM is set up depending on your question. Take a look at the GLM instructions [here](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/GLM) to get a better idea of how to organise your GLM.
In R, run the following script:
```
3.6_GLMSetup.R
```
After doing this, open the GLM gui in FSL. We will create two GLMs, one for the F tests (which we will evaluate using FSL's [Randomise](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Randomise)) and one for the t tests (which we will evaluate using FSL's [dual regression](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/DualRegression)). The reason for including both is that you should look at the outcomes of your F tests to see if they are statistically significant, before you go on to look at the dual regression output. This will also allow you to be smarter with your corrections for multiple comparisons.


In the ubuntu terminal, type:
```
Glm
```

<table>
   <tr>
       <td>           
           In Glm setup window:</br>
1. Change first drop down menu to "Higher-level/non-timeseries design"
    2. Change #inputs to equal the number of participants (e.g., will be 250 for the final analysis for workpackage 1)

In General Linear Model window:
1. Change "Number of main EVs" to 4 (this will change depending on what you have included in your GLM)
1. Click "Paste" 

In Higher-level model - paste window:
1. Click "clear"
1. Paste GLM from `3.6_GLMSetup.R` by highlighting and copying all content from `GLM_faecalLCMS.csv`, then clicking inside the paste window using the scroller button of your mouse.
1. Click "OK"

In General Linear Model window:
1. Enter the following names for the EVs (or whatever your EVs actually are):
    "age","GABA","Glutamate", "Glutamine"
1. Click on "Contrasts & F-tests" tab
1. Change number of "Contrasts" to 3
1. Change number of F tests to 3
1. Contrasts should be set up as follows:
<table>
  <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>F1</td>
      <td>F2</td>
      <td>F3</td>
    </tr>
  <tr>
      <td>GABA</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>🟨</td>
      <td></td>
      <td></td>
   </tr>
  <tr>
      <td>Glutamate</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td></td>
      <td>🟨</td>
      <td></td>
   </tr>
     <tr>
      <td>Glutamine</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td></td>
      <td></td>
      <td>🟨</td>
   </tr>
</table>

1. Save as "ICA_LCMS_Ftest" in `/storage/shared/research/cinn/2020/gbgaba/scripts/GLMs`
           
#### Now repeat for t tests
           
In General Linear Model window:
1. Click on "Contrasts & F-tests" tab
1. Change number of "Contrasts" to 6
1. Change number of F tests to 0
1. Contrasts should be set up as follows:
<table>
  <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  <tr>
      <td>GABA+</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
   </tr>
   <tr>
       <td>GABA-</td>
       <td>0</td>
       <td>0</td>
       <td>-1</td>
       <td>0</td>
       <td>0</td>
    </tr>
  <tr>
      <td>Glutamate+</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
   </tr>
   <tr>
       <td>Glutamate-</td>
       <td>0</td>
       <td>0</td>
       <td>0</td>
       <td>-1</td>
       <td>0</td>
   </tr>
     <tr>
      <td>Glutamine+</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
   </tr>
   <tr>
       <td>Glutamine-</td>
       <td>0</td>
       <td>0</td>
       <td>0</td>
       <td>0</td>
       <td>-1</td>
   </tr>
</table>

1. Save as "ICA_LCMS" in `/storage/shared/research/cinn/2020/gbgaba/scripts/GLMs`

1. Exit Glm GUI

</table>

**For Work Package 2, the GLM will need to be set up differently to account for the repeated-measures, within-subject design. To see how this should be done, refer to the image below.**</br>

![glm](Supplementary_materials/GLM_longitudinalanalysis.png)</br>

### 3.7. Create group-level independent components using FSL's MELODIC. 
*NOTE THIS IS SET UP FOR WP1 AND WILL NOT BE APPROPRIATE FOR WP2*

In the ubuntu terminal, type:
```
3.7_melodic.sh
```

### 3.8. Dual regression
*NOTE THIS IS SET UP FOR WP1 AND WILL NOT BE APPROPRIATE FOR WP2*

Run dual regression in FSL to estimate a "version" of each of the group-level spatial maps for each subject. Dual regression regresses the group-spatial-maps into each subject's 4D dataset to give a set of timecourses (stage 1) and then regresses those timecourses into the same 4D dataset to get a subject-specific set of spatial maps (stage 2). In the ubuntu terminal, type:
```
3.8_dualregression.sh
```

### 3.9. Randomise
Dual regression will not perform an ANOVA and only t-tests can be viewed in the dual regression output directory at present. To run F-tests you need to run randomise on the dual regression output. This isn't necessary for WP1 but may be for WP2 (alternatively, you may want to use [PALM](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM)) so I include it here for completeness. </br>
In the ubuntu terminal window, type:
```
3.9_randomise.sh
```

Use information contained in inferential_stats_ftests_WP1.txt and inferential_stats_ttests_WP1.txt to determine which independent components demonstrate a statistically significant effect. Note that you should correct for multiple comparisons, e.g., by using the False Discovery Rate. There is a matlab script for determining FDR (`FDRcorr.m`) contained in this repository if you want to use that.

    
### Notes

1. readout time=  ([(EPI factor (89))/(parallel image (1) )-1]*echo spacing (0.58 ms))/1000=.05104
1. Analysis scripts have been developed mainly for analysis of workpackage 1 data but should be easy enough to modify for use in workpackage 2. The main modifications needed for workpackage 2 will be in GLM design and implementation. Hopefully the preprocessing steps shouldn't need much tinkering though.
1. See this [article](https://www.sciencedirect.com/science/article/pii/S1053811914010428#f0010) for an idea of how to do the repeated measures design.