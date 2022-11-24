% Carolyn McNabb
% September 2021

% GBGABA BRAIN DATA ANALYSIS
% QualityCheck.m will run the Osprey preprocessing pipeline in MATLAB.
% It will use the data specified in the quality_check_setup_MC.m or
% quality_check_setup_OCC.m functions for individual preprocessing,
% or from group_analysis_setup_MC.m or group_analysis_setup_OCC.m for group preprocessing.

% Define voxel of interest for quality check:
% (options are MC and OCC).
% NOTE: this is only required for individual quality checks.
 VOI = ['OCC']; 

% Run the pre-processing:
%%% (comment out depending on individual or group pre-processing)
%%% for individual pre-processing, run:
 [MRSCont] = OspreyJob(sprintf('quality_check_setup_%s.m', VOI));
%%% for group MC pre-processing, run:
%%% [MRSCont] = OspreyJob(sprintf('group_analysis_setup_MC.m'));
%%% or for OCC, run:
%%% %%% [MRSCont] = OspreyJob(sprintf('group_analysis_setup_OCC.m'));

% Run the Osprey Workflow as follows:

% Load the raw metabolite and water reference data:
 [MRSCont] = OspreyLoad(MRSCont);

% Translate the raw, un-aligned, un-average data into spectra for modeling:
 [MRSCont] = OspreyProcess(MRSCont);

% Create a binary voxel mask and coregister this to structural image, in
% order to reproduce original voxel placement:
 [MRSCont] = OspreyCoreg(MRSCont);

% Segment structural image into gray matter (GM), white matter (WM), and
% cerebrospinal fluid (CSF). Overlay coregistered voxel mask with GM, WM 
% and CSF probability maps and calculate fractional tissue volumes for 
% GM, WM, and CSF:
 [MRSCont] = OspreySeg(MRSCont);

% Model the processed spectra:
 [MRSCont] = OspreyFit(MRSCont);

% Calculate quantitative outputs:
 [MRSCont] = OspreyQuantify(MRSCont);

% Provide summary visualisations:
 [MRSCont] = OspreyOverview(MRSCont);

