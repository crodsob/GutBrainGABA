# BIDS conversion instructions
#### Claudia Rodriguez-Sobstel
#### Adapted from Carolyn McNabb https://github.com/CarolynMcNabb/GutBrainGABA

LAST UPDATED: 24 November 2022

The first time you run these scripts, whether on the virtual machine (VM) or on MacOS, you will need to make the scripts executable. To do this, run the following command in the terminal, replacing `script_name` with the relavant script name and `path_to_script` with the relevant path to the directory where your scripts are kept. Note that this is likely to be a different path for the VM and MacOS. You only have to do this **ONCE** for each script.
```
chmod u+x path_to_script/script_name
```

Every time you log onto a terminal, you need to remind it where your scripts are (or you can modify your bash profile). Once again, replace `path_to_script` with your actual path. <br/>
In the Ubuntu terminal, type:
```
PATH=$PATH:path_to_script
export PATH
```

**N.B. All the paths in the scripts are specific to my own directories - the paths for the VM should be able to be used without adjusting but the MacOS paths will obviously need to be changed to match your own before continuing.** 

---

##  VM setup

1.1. Create Vanilla VM in nutanix https://rrc.reading.ac.uk:9440/console/#login </br>
1.2. Open VM in NoMachine by pasting IP address from Nutanix</br>
1.3. Open Terminal window</br>
```
rm -r ~/.mozilla #to clear any open firefox applications
```
--

## Convert dicoms to BIDS format
N.B. Conversion of diffusion data to BIDS format may later be updated to use ADWI-BIDS https://arxiv.org/pdf/2103.14485.pdf 

BIDS filenames must follow this pattern:
```
sub-<label>_ses-<label>_task-<label>_acq-<label>_ce-<label>_rec-<label>_dir-<label>_run-<index>_mod-<label>_echo-<index>_flip-<index>_inv-<index>_mt-<label>_part-<label>_recording-<label>
t1_mprage_DC_sag_HCP_256_32ch
```
<table>
  <tr>
      <td>t1_mprage_DC_sag_HCP_256_32ch</td>
      <td>MPRAGE structural whole-brain</td>
      <td>anat</td>
      <td>sub-00x_T1w</td>
   </tr>
   <tr>
       <td>Resting_ep2d_bold_p2_s4_32ch_TR1500_2.1x2.1_68_32-head-Coil</td>
       <td>Resting state fMRI</td>
       <td>func</td>
       <td>sub-00x_task-rest_bold</td>
   </tr>
    <tr>
        <td>gre_field_mapping_32ch</td>
        <td>Magnitude and phase images (2 files)</td>
        <td>fmap</td>
        <td>sub-00x_magnitude1; sub-00x_magnitude2; sub-00x_phasediff</td>
    </tr>
</table>

#### Initial environment setup
##### 2.1. Install python 3 and dcm2bids
In terminal, type:
```
module load anaconda
sudo apt install python3-pip
pip install dcm2bids
```
##### 2.2. Set up environment for dcm2bids 
```
sudo apt install gedit
gedit environment.yml 
```
Paste in the following:
```
name: dcm2bids
channels:
    - conda-forge
dependencies:
    - dcm2niix
    - dcm2bids
    - pip
```

Add path:
```
PATH=$PATH:/opt/anaconda/bin/
export PATH
```

Create conda environment and activate:
```
conda env create -f environment.yml --prefix /storage/shared/research/cinn/2020/gbgaba/scripts_claudia/conda_env

source activate /storage/shared/research/cinn/2020/gbgaba/scripts_claudia/conda_env
cd /storage/shared/research/cinn/2020/gbgaba/
```

#### If environment has already been setup
##### 2.1. Add path to dcm2bids conversion script
```
PATH=$PATH:/storage/shared/research/cinn/2020/gbgaba/scripts_claudia/
export PATH
```

##### 2.2. Run the dcm2bids conversion script
The script will:
- activate the conda environment, 
- test whether dcm2bids is working, and
- convert the raw data to BIDS format.

Note: You will be prompted to enter the participant ID and session number. 
```
0.0_dcm2bids.sh
```


2.3. Convert raw data to BIDS format with dcm2bids
First, test that dcm2bids is working by typing
```
dcm2bids --help
```
Use the dcm2bids helper function to look at your json files (associated with each of your nifti files - these will be in the tmp_dcm2bids folder).
```
dcm2bids_helper -d /storage/shared/research/cinn/2020/gbgaba/raw/GBGABA_pilot2
```

Next, make sure dcm2bids_config.json contains the following:
```
{
    "descriptions": [
        {
        "dataType": "anat",
        "modalityLabel": "T1w",
        "criteria": {
            "ImageType":  ["ORIGINAL", "PRIMARY", "M", "NORM", "DIS2D"],
            "SequenceName": "*tfl3d1_16ns*",
            "SeriesDescription": "t1_mprage*"
                    }
        },
        {
        "dataType": "func",
        "modalityLabel": "bold",
        "customLabels": "task-rest",
        "criteria": {
            "SeriesDescription": "*cmrr_mbep2d_bold_HCP*"
            },
        "sidecarChanges": {
                "TaskName": "rest"
            }
        },
        {
        "dataType": "func",
        "modalityLabel": "sbref",
        "customLabels": "task-rest",
        "criteria": {
            "SeriesDescription": "*cmrr_mbep2d_bold_SB*"
            },
        "sidecarChanges": {
                "TaskName": "rest"
            }
        },
        {
        "dataType": "fmap",
        "modalityLabel": "magnitude1",
        
        "criteria": {
            "SeriesDescription": "gre_field_mapping_32ch", 
            "SidecarFilename": "*_e1.*"
            },
        "intendedFor": 0
        },
        {
        "dataType": "fmap",
        "modalityLabel": "magnitude2",
        
        "criteria": {
            "SeriesDescription": "gre_field_mapping_32ch", 
            "SidecarFilename": "*_e2.*"
            },
        "intendedFor": 0
        },
        {
        "dataType": "fmap",
        "modalityLabel": "phasediff",
        
        "criteria": {
            "SidecarFilename": "*_e2_ph*"
            },
        "intendedFor": 0
        },
        {
        "dataType": "anat",
        "modalityLabel": "mp2rage",
        "customLabels": "TI1_magnitude",
        "criteria": {
            "ProtocolName": "*mp2rage*",
            "ImageType": ["ORIGINAL", "PRIMARY", "M", "ND", "NORM"],
            "SeriesDescription": "*t1_mp2rage_sag_p3_iso_INV1*"
            }
        },
        {
        "dataType": "anat",
        "modalityLabel": "mp2rage",
        "customLabels": "TI2_magnitude",
        "criteria": {
            "ProtocolName": "*mp2rage*",
            "ImageType": ["ORIGINAL", "PRIMARY", "M", "ND", "NORM"],
            "SeriesDescription": "*t1_mp2rage_sag_p3_iso_INV2*"
            }
        },
        {
        "dataType": "anat",
        "modalityLabel": "mp2rage",
        "customLabels": "UNI",
        "criteria": {
            "ProtocolName": "*mp2rage*",
            "ImageType": ["DERIVED", "PRIMARY", "M", "ND", "UNI"],
            "SeriesDescription": "*t1_mp2rage_sag_p3_iso_UNI_Images*"
            }
        },
        {
        "dataType": "anat",
        "modalityLabel": "mp2rage",
        "customLabels": "TI1_phase",
        "criteria": {
            "ProtocolName": "*mp2rage*",
            "ImageType": ["ORIGINAL", "PRIMARY", "P", "ND", "PHASE"],
            "SeriesDescription": "*t1_mp2rage_sag_p3_iso_RR_INV1*"
            }
        },
        {
        "dataType": "anat",
        "modalityLabel": "mp2rage",
        "customLabels": "TI2_phase",
        "criteria": {
            "ProtocolName": "*mp2rage*",
            "ImageType": ["ORIGINAL", "PRIMARY", "P", "ND", "PHASE"],
            "SeriesDescription": "*t1_mp2rage_sag_p3_iso_RR_INV2*"
            }
        }

    ]
}

```


Then type into terminal (within the conda environment) - MAKING SURE TO REPLACE THE SUBJECT ID AND SESSION ID:
```
dcm2bids -d /storage/shared/research/cinn/2020/gbgaba/raw/GBGABA_W0001/ -p W0001 -s 01 -c /storage/shared/research/cinn/2020/gbgaba/scripts/code/dcm2bids_config.json 
```

Or if the subject is in Work Package 2:
```
dcm2bids -d /storage/shared/research/cinn/2020/gbgaba/raw/GBGABA_W2AB002S1/ -p W2AB002 -s 01 -c /storage/shared/research/cinn/2020/gbgaba/scripts/code/dcm2bids_config.json 
```

And Repeat for every subject


##TO DO
Add modality agnostic file (dataset_description.json) https://bids-specification.readthedocs.io/en/stable/03-modality-agnostic-files.html 


	
### BIDS validation
2.4. Validate BIDS format using BIDS validator https://pypi.org/project/bids-validator 
In terminal window (not in python) type:
```
pip install bids_validator
python3.7 2.1_validate_bids.py
```
OR go to https://bids-standard.github.io/bids-validator/ and import bids parent folder (folder containing all subjects)

2.5 Finalised folder structure, including directories for analyses
```
/storage/shared/research/cinn/2020/gbgaba/
   GBGABA_BIDS/
      derivatives/
         relaxometry/
            preprocessed/
               sub_001/
                   ses-01/
                   …
             analysis/               
         fMRI/
             preprocessed/
               sub_001/
                   ses-01/
                   …
             analysis/ 
             ... 
      sub_001/
          ses-01/
             anat/
             mrs/
             fmap/
             func/
      sub_002/
         ...
```

