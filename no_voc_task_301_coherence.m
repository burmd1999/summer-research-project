% compute and save the coherence matrix for each pair of channels from the
% no vocal task 301 data set

%% load eeglab 
eeglab

%% import data set
EEG = pop_loadset('sub-301_sz_eeg_clean.set', '/Users/bryncrandles/Documents/Summer Research Project/summer-research-project/datasets')

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
save('no_voc_task_301_coh.mat', 'no_voc_task_301_coh')

