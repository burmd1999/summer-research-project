% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% open text file, read file names 
% fileID = fopen('eegdatasets_list_all.txt', 'r');
% eegdatasets_list = textscan(fileID, '%s');
% fclose(fileID);
% eegdatasets_list = eegdatasets_list{1};

% folder of data files
datafolder = '/home/bc11xx/projects/def-wjmarsha/bc11xx/eegfiles';

% pattern of files of interest
filepattern = fullfile(datafolder, 'sub-3*_sz_eeg_clean.set');

% directory of data files
datafiles = dir(filepattern);

condition_lengths = cell(length(datafiles), 1);
for i = 1:length(datafiles)
       filename = datafiles(i).name;
       fullfilename = fullfile(datafiles(i).folder, filename);
       eeglab
       EEG = pop_loadset(fullfilename);
       condition_lengths{i} = ext_all_cond(EEG);
end

save('condition_lengths.mat', 'condition_lengths', '-v7.3')

exit