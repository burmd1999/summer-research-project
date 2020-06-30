% compute and save the coherence matrix for each pair of channels from the
% no vocal task 301 data set

% load eeglab 
eeglab

% import data set
EEG = pop_loadset('sub-303_sz_eeg_clean.set')

% variables 
data = EEG.data; 
srate = EEG.srate;
brkpnts = [0 EEG.pnts];

% compute coherence
[no_voc_task_303_coh, pairs_303] = coh(data, srate, brkpnts);

% save coherence 
save('no_voc_task_303_coherence.mat', 'no_voc_task_303_coh', 'pairs_303') 
