# BIDS conversion instructions

#### CAROLYN MCNABB 
LAST UPDATED: 26 July 2021

###  VM setup
1.1. Create Vanilla VM in nutanix https://rrc.reading.ac.uk:9440/console/#login 
1.2. Open VM in NoMachine by pasting IP address from Nutanix
1.3. Open Terminal window
```
rm -r ~/.mozilla #to clear any open firefox applications
```

### Convert dicoms to BIDS format
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
       <td>ep2d_diff_mddw_p2_s4_2mm_2avg_32headcoil</td>
       <td>Blip up diffusion MRI </td>
       <td>dwi</td>
       <td>sub-00x_dir-up_dwi</td>
    </tr>
       <tr>
       <td>diff_blip_down_mddw_p2_s4_2mm_2avg_32headcoil</td>
       <td>Blip down diffusion MRI</td>
       <td>dwi</td>
       <td>sub-00x_dir-down_dwi</td>
    </tr>
    <tr>
        <td>gre_field_mapping_32ch</td>
        <td>Magnitude and phase images (2 files)</td>
        <td>fmap</td>
        <td>sub-00x_magnitude1; sub-00x_magnitude2; sub-00x_phasediff</td>
    </tr>
</table>


2.1. Install python 3 and dcm2bids
In terminal, type:
```
sudo apt install python3.7
sudo apt install python-pip
pip install dcm2bids
```
2.2. Set up environment for dcm2bids
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
conda env create -f environment.yml --prefix /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/conda_env/

source activate /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/conda_env
cd /storage/shared/research/cinn/2018/GUTMIC/
```
2.3. Convert raw data to BIDS format with dcm2bids
First, test that dcm2bids is working by typing
```
dcm2bids --help
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
            "SeriesDescription": "*Resting_ep2d_bold*"
            },
 	"sidecarChanges": {
                "TaskName": "rest"
		}
        },
        {
        "dataType": "fmap",
        "modalityLabel": "magnitude1",
        
        "criteria": {
	"SeriesDescription": "gre_field_mapping_32ch", 		 "SidecarFilename": "*_e1.*"
            },
        "intendedFor": 0
        },
	{
	"dataType": "fmap",
        "modalityLabel": "magnitude2",
        
        "criteria": {
	"SeriesDescription": "gre_field_mapping_32ch", 		 "SidecarFilename": "*_e2.*"
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
        }
        
    ]
}
```


Then type into terminal (within the conda environment):
```
2.0_dcm2bids.sh
```

Alternatively, type:
```
cd /storage/shared/research/cinn/2018/GUTMIC/CM_MRS/
dcm2bids -d /storage/shared/research/cinn/2018/GUTMIC/raw/GUTMIC_002/ -p 002 -c /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/code/dcm2bids_config.json 
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

2.5 Finalise folder structure, including making directories (mkdir) for analysis
```
/storage/shared/research/cinn/2018/GUTMIC/
   func_diff/
      derivatives/
         TBSS/
            preprocessed/
               sub_001/
               …
             analysis/               
         fMRIprep/
      sub_001/
         anat/
         dwi/
         fmap/
         func/
      sub_002/
         ...
```

