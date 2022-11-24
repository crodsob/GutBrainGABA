% Carolyn McNabb
% September 2021

% GBGABA BRAIN DATA ANALYSIS
% OspreySetup.m adds paths to directories and folders required for 
% pre-processing of MRS data.

% change into top dir so you can add matlab path
 cd('/')

% add path to SPM12
 addpath('/Users/bhismalab/Documents/GitHub/spm12')

% add folders and subfolders for Osprey to path
 addpath(genpath('/Users/bhismalab/Documents/GitHub/osprey'))

% add path to data
 addpath(genpath('/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS'))

% change directory to the folder containing Osprey jobfiles
 cd('/Users/bhismalab/Documents/GitHub/GutBrainGABA/MRS')


