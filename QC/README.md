# GBGABA MRI Quality Control
Carolyn McNabb 2021 - Find me at https://github.com/CarolynMcNabb</br>
Quality control analysis uses [visualqc](https://raamana.github.io/visualqc/installation.html) on a MacOS Big Sur operating system and [pyfMRIqc](https://drmichaellindner.github.io/pyfMRIqc/) on an Ubuntu MATE 16.04 operating system (8GB).</br> 
All analysis scripts are available [here](https://github.com/CarolynMcNabb/GutBrainGABA/tree/main/QC)


## Initial setup
In terminal on MacOS, type:
```
pip install -U visualqc
```

## Check T1w (MPRAGE) anatomical data quality
In MacOS terminal, type:
```
visualqc_anatomical --bids_dir=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS --out_dir /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/anat/T1w  --id_list /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/qc_sub_list.txt --mri_name 'ses-01/anat/sub*_T1w.nii.gz' 
```

## Check magnitude and phase images for MP2RAGE anatomical data quality
```
visualqc_anatomical --bids_dir=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS --out_dir /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/anat/mp2rage  --id_list /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/qc_sub_list.txt --mri_name 'ses-01/anat/sub*_magnitude_mp2rage.nii.gz' 

visualqc_anatomical --bids_dir=/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS --out_dir /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/anat/mp2rage  --id_list /Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/QC/qc_sub_list.txt --mri_name 'ses-01/anat/sub*_phase_mp2rage.nii.gz' 
```



## Check functional data quality
In a NeuroDebian VM Ubuntu terminal (these details are specific to the University of Reading set up), type:
```
module load anaconda3
cd /usr/share/pyfMRIqc/
python pyfMRIqc/pyfMRIqc.py

```
This will open the GUI, which will allow you to load your functional data and view the output. If you wish, you can use the raw data or the motion corrected data and motion output files.

---
Please cite:

Williams, B. and Lindner, M., 2020. pyfMRIqc: A Software Package for Raw fMRI Data Quality Assurance. Journal of Open Research Software, 8(1), p.23. DOI: http://doi.org/10.5334/jors.280

Pradeep Reddy Raamana. VisualQC: Assistive tools for easy and rigorous quality control of neuroimaging data. http://doi.org/10.5281/zenodo.1211365