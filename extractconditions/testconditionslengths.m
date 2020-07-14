% open text file, read file names 
addpath('/Users/bryncrandles/Documents/Summer Research Project/summer-research-project', '/Users/bryncrandles/Documents/Summer Research Project/summer-research-project/datasets')
fileID = fopen('eegdatasets_list.txt', 'r');
eegdatasets_list = textscan(fileID, '%s');
fclose(fileID);
eegdatasets_list = eegdatasets_list{1};

test_cond_length = cell(length(eegdatasets_list), 2);

for k = 1:length(eegdatasets_list)
    eeglab
    EEG = pop_loadset(eegdatasets_list{k});
    test_cond_length{k, 1} = ext_all_cond(EEG);
    test_cond_length{k, 2} = EEG.srate;
end

%%
for i = 1:length(test_cond_length)
    for j = 1:length(test_cond_length{i})
    test_cond_length{i}{j, 4} = ((length(test_cond_length{i}{j, 2}) - 1)/EEG.srate)/60;
    end
end
