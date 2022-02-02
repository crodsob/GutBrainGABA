%% QualityCheck.m
% Carolyn McNabb 2021
%   This script will run the Osprey preprocessing pipeline in MATLAB, without having to use the Osprey GUI.
%   To view the output, you will need to load the MRSCont object into the GUI

%Voxel of interest for quality check
VOI = 'MC'; %options are OCC and MC


[MRSCont] = OspreyJob(sprintf('quality_check_%s.m',VOI))
[MRSCont] = OspreyLoad(MRSCont)
[MRSCont] = OspreyProcess(MRSCont)
[MRSCont] = OspreyCoreg(MRSCont)
[MRSCont] = OspreySeg(MRSCont)
[MRSCont] = OspreyFit(MRSCont)
[MRSCont] = OspreyQuantify(MRSCont)