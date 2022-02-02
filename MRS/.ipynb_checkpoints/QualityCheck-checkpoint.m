%% 2.2_runOsprey.m
%   This script will run the Osprey preprocessing pipeline in MATLAB, without having to use the Osprey GUI.
%   To view the output, you will need to load the data into the GUI

[MRSCont] = OspreyJob('quality_check_OCC.m')
[MRSCont] = OspreyLoad(MRSCont)
[MRSCont] = OspreyProcess(MRSCont)
[MRSCont] = OspreyCoreg(MRSCont)
[MRSCont] = OspreySeg(MRSCont)
[MRSCont] = OspreyFit(MRSCont)
[MRSCont] = OspreyQuantify(MRSCont)