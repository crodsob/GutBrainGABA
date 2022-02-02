%% GBGABA quality check jobfile
%   This function describes an Osprey job defined in a MATLAB script.
%
% Define Subject and Session for quality check
sub = 'sub-W0001';
ses = 'ses-01';

%Voxel of interest for quality check
VOI = 'OCC'; %options are OCC and MC

% Specify MRSCont file path
outputFile = sprintf('/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/MRS/preprocessed/%s/%s/%s_%s_%s/quality_check_%s.mat', sub, ses, sub, ses, VOI, VOI);

%Load MRSCont file from output folder
load(outputFile)

%Open the MRSCont file in the Osprey GUI
OspreyGUI(MRSCont)