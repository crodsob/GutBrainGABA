% Carolyn McNabb
% September 2021

% GBGABA BRAIN DATA ANALYSIS
% ViewOutput.m will open the pre-processed MRS data in the Osprey GUI 
% for visual inspection. 

% Define subject and session for quality check:
% NOTE: this is only required for individual quality checks.
 sub = 'sub-W2AB054';
 ses = 'ses-03';
 
% Define voxel of interest for quality check:
% (options are MC and OCC). 
% NOTE: this is only required for individual quality checks.
 VOI = ['OCC']; 

% Specify MRSCont file path:
%%% (comment out depending on individual or group visual inspection)
%%% for individual visual inspection, run:
outputFile = sprintf('/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/MRS/preprocessed/%s/%s/%s_%s_%s/quality_check_setup_%s.mat', sub, ses, sub, ses, VOI, VOI);
%%% for group MC visual inspection, run:
%%% outputFile = sprintf('/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/MRS/analysis/group_analysis_MC/group_analysis_setup_MC.mat');
%%% or for OCC, run:
%%% outputFile = sprintf('/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/MRS/analysis/group_analysis_OCC/group_analysis_setup_OCC.mat');

% Load MRSCont file from output folder:
load(outputFile);

% Open the MRSCont file in the Osprey GUI to review:
OspreyGUI(MRSCont);

