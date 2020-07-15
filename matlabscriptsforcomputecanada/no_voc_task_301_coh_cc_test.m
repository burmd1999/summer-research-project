% compute and save the coherence matrix for each pair of channels from the
% no vocal task 301 data set

%% set paths
addpath('/home/bc11xx/MATLAB', '/home/bc11xx/MATLAB/eeglab2019_1')

%% load eeglab 
eeglab

%% import data set
EEG = pop_loadset('sub-301_sz_eeg_clean.set', '/home/bc11xx/MATLAB')

%% find breakpoints
type = string({EEG.event.type});
b = find(type == 'boundary');
latency = cell2mat({EEG.event.latency});
boundarypnts = [floor(latency(b))];

%% variables 
data = EEG.data; 
srate = EEG.srate;
brkpnts = [0 boundarypnts EEG.pnts];

%% compute coherence
[no_voc_task_301_coh] = coh(data, srate, brkpnts);

% save coherence 
save('CC_2_no_voc_task_301_coh.mat', 'no_voc_task_301_coh')

exit

