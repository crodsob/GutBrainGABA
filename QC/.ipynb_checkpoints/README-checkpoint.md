# GBGABA MRI Quality Control
#### Claudia Rodriguez-Sobstel
#### Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA
Quality control analysis uses [visualqc](https://raamana.github.io/visualqc/installation.html) on a MacOS Big Sur operating system and [pyfMRIqc](https://drmichaellindner.github.io/pyfMRIqc/) on an Ubuntu MATE 16.04 operating system (8GB).</br> 

All analysis scripts are available [here](https://github.com/CarolynMcNabb/GutBrainGABA/tree/main/QC)

LAST UPDATED: 24 November 2022

---
The first time you run these scripts, whether on the virtual machine (VM) or on MacOS, you will need to make any bash scripts executable (you don't need to worry about this for the Matlab scripts). To do this, run the following command in the terminal, replacing `script_name` with the relavant script name and `path_to_script` with the relevant path to the directory where your scripts are kept. Note that this is likely to be a different path for the VM and MacOS. You only have to do this **ONCE** for each script.
```
chmod u+x path_to_script/script_name
```

Every time you log onto a terminal, you need to remind it where your scripts are (or you can modify your bash profile). Once again, replace `path_to_script` with your actual path. In the terminal, type:
```
PATH=$PATH:path_to_script
export PATH
```

**N.B. All the paths in the scripts are specific to my own directories - the paths for the VM should be able to be used without adjusting but the MacOS paths will obviously need to be changed to match your own before continuing.** 

---
## Check T1w (MPRAGE) anatomical data quality
### Initial setup
In terminal on MacOS, type:
```
pip install -U visualqc
```

In MacOS terminal, modify path:
```
PATH=$PATH:/Users/bhismalab/Documents/GitHub/GutBrainGABA/QC
export PATH
```

And run the following script, which will use visualqc to check quality of T1w (MPRAGE) anatomical data:
```
4.0_visualqc_check.sh
```

## Check magnitude and phase images for MP2RAGE anatomical data and rs-fMRI data for quality
This step should be conducted using the NeuroDebian VM (Ubuntu), or wherever FSL is installed. <br/>

In the Ubuntu terminal, type:
```
4.1_mp2rage_func_check.sh
```



## Additionally check functional data quality using pyfMRIqc
In a NeuroDebian VM Ubuntu terminal (these details are specific to the University of Reading set up), type:
```
4.2_pyfMRIqc.sh

```
## Finally, open the pyfMRIqc and FEAT preprocessing outputs for inspection
In terminal on MacOS, type:
```
4.3_check_outputs.sh
```


---
#### Please cite:

Williams, B. and Lindner, M., 2020. pyfMRIqc: A Software Package for Raw fMRI Data Quality Assurance. Journal of Open Research Software, 8(1), p.23. DOI: http://doi.org/10.5334/jors.280

Pradeep Reddy Raamana. VisualQC: Assistive tools for easy and rigorous quality control of neuroimaging data. http://doi.org/10.5281/zenodo.1211365