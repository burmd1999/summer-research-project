% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% open text file, read file names 
fileID = fopen('eegdatasets_list_all.txt', 'r');
eegdatasets_list = textscan(fileID, '%s');
fclose(fileID);
eegdatasets_list = eegdatasets_list{1};

condition_lengths = cell(length(eegdatasets_list), 1);
for k = 1:length(eegdatasets_list)
    eeglab
    EEG = pop_loadset(eegdatasets_list{k})
    condition_lengths{k} = ext_all_cond(EEG);
end

for i = 1:length(condition_lengths)
    for j = 1:length(condition_lengths{i})
    condition_lengths{i}{j, 4} = ((length(condition_lengths{i}{j, 2}) - 1)/EEG.srate)/60;
    end
end

save('condition_lengths.mat', 'condition_lengths', '-v7.3')

exit