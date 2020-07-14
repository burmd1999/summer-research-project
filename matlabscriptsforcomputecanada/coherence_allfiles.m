% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% open text file, read file names 
fileID = fopen('eegdatasets_list_all.txt', 'r');
eegdatasets_list = textscan(fileID, '%s');
fclose(fileID);
eegdatasets_list = eegdatasets_list{1};

% allfiles_coh_psd = cell(length(eegdatasets_list), 1);
% parfor i = 1:length(eegdatasets_list)
%     eeglab
%     EEG = pop_loadset(eegdatasets_list{i});
%     all_cond = ext_all_cond(EEG);
%     srate = EEG.srate;
%     coherence = cell(length(all_cond), 1);
%     powerspd = cell(length(all_cond), 1);
%     for j = 1:length(all_cond)
%         coherence{j} = coh(all_cond{j, 2}, srate, all_cond{j, 3}); 
%         powerspd{j} = PSD(all_cond{j, 2}, srate, all_cond{j, 3});
%     end
%     file_coh_psd = cell(1, 3);
%     file_coh_psd{1} = all_cond;
%     file_coh_psd{2} = coherence;
%     file_coh_psd{3} = powerspd;
%     allfiles_coh_psd{i} = file_coh_psd;
% end

allfiles_coh_psd = cell(length(eegdatasets_list), 1);
parfor i = 1:length(eegdatasets_list)
       eeglab
       EEG = pop_loadset(eegdatasets_list{i});
       all_cond = ext_all_cond(EEG);
       srate = EEG.srate;
       


% allfiles_coh_psd = cell(length(allfiles_coh_psd), 1);
% for i = 1:length(allfiles_coh_psd)
%     allfiles_coh_psd{i} = cell(length(allfiles_coh_psd{i}), 3);
%     for j = 1:length(allfiles_coh_psd{i})
%         allfiles_coh_psd{i}(:, 1) = allfiles_coh_psd{i, 1}(:, 1);
%         allfiles_coh_psd{i}{j, 2} = coh(allfiles_coh_psd{i, 1}{j, 2}, allfiles_coh_psd{i, 2}, allfiles_coh_psd{i, 1}{j, 3});
%         allfiles_coh_psd{i}{j, 3} = PSD(allfiles_coh_psd{i, 1}{j, 2}, allfiles_coh_psd{i, 2}, allfiles_coh_psd{i, 1}{j, 3});
%     end
% end

save('allfiles_coh_psd.mat', 'allfiles_coh_psd', '-v7.3')

exit