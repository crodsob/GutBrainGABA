%OSPREY PATH SETUP
%CAROLYN MCNABB 2021

%change into top dir so you can add matlab path
cd('/')

%add path to SPM12
% addpath('/Users/Carolyn/Documents/MATLAB/spm12')
addpath('/Volumes/GoogleDrive/My Drive/GitHub/CAP_Toolbox/spm12')

%add folders and subfolders for Osprey to path
addpath(genpath('/Volumes/GoogleDrive/My Drive/GitHub/osprey'))

%add path to data
addpath(genpath('/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS'))

%change directory to the folder containing Osprey jobfiles
cd('/Volumes/GoogleDrive/My Drive/GitHub/GutBrainGABA/MRS_Osprey_analysis')



