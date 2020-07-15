% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% open text file, read file names 
fileID = fopen('eegdatasets_list_all.txt', 'r');
eegdatasets_list = textscan(fileID, '%s');
fclose(fileID);
eegdatasets_list = eegdatasets_list{1};

condition_lengths = cell(length(eegdatasets_list), 1);
parfor i = 1:length(eegdatasets_list)
       eeglab
       EEG = pop_loadset(eegdatasets_list{i})
       condition_lengths{i} = ext_all_cond(EEG);
end

save('condition_lengths.mat', 'condition_lengths', '-v7.3')

exit