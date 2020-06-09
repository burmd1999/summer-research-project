% compute and save the coherence matrix for each pair of channels from the
% no vocal task 301 data set

% load eeglab 
eeglab

% import data set
EEG = pop_loadset('sub-301_sz_eeg_clean.set')

% variables 
data = EEG.data; 
srate = EEG.srate;
brkpnts = [0 EEG.pnts];

% compute coherence
[no_voc_task_301_coh, pairs_301] = coh(data, srate, brkpnts);

% save coherence 
save('no_voc_task_301_coherence.mat', 'no_voc_task_301_coh', 'pairs_301')

