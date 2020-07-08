% add necessary paths for eeglab, text file, and data sets
addpath('/home/bc11xx/projects/def-wjmarsha/bc11xx', '/home/bc11xx/MATLAB/eeglab2019_1')

% open text file, read file names 
fileID = fopen('eegdatasets_list.txt', 'r');
eegdatasets_list = textscan(fileID, '%s');
fclose(fileID);
eegdatasets_list = eegdatasets_list{1};

% loop - for each data file, extract data for each condition and compute coherence for each condition 
for i = 1:length(eegdatasets_list)
    eeglab
    EEG = pop_loadset(eegdatasets_list{i})
    % extract all of the conditions
%     [restingdata, restingbrkpnts] = ext_rest_cond(EEG);
%     [musicdata, musicbrkpnts] = ext_music_cond(EEG);
%     [facesdata, facesbrkpnts] = ext_faces_cond(EEG):
%     [eyesopendata, eyesopenbrkpnts] = ext_eopen_cond(EEG);
%     [eyescloseddata, eyesclosedbrkpnts] = ext_eclosed_cond(EEG);
%     [hapmdata, hapmbrkpnts] = ext_hapm_cond(EEG);
%     [joymdata, joymbrkpnts] = ext_joym_cond(EEG);
%     [sadmdata, sadmbrkpnts] = ext_sadm_cond(EEG);
%     [feamdata, feambrkpnts] = ext_feam_cond(EEG);
%     [hapyfacedata, hapyfacebrkpnts] = ext_hapyface_cond(EEG);
%     [angyfacedata, angyfacebrkpnts] = ext_angyface_cond(EEG);
%     [neutfacedata, neutfacebrkpnts] = ext_neutface_cond(EEG);
%     [fearfacedata, fearfacebrkpnts] = ext_fearface_cond(EEG);
    all_cond = ext_all_cond(EEG);
    
    for j = 1:length(all_cond)
        
    % compute coherence for each condition and put it in a structure
    
%     resting_coh = coh(restingdata, EEG.srate, restingbrkpnts);
%     music_coh = coh(musicdata, EEG.srate, musicbrkpnts);
%     faces_coh = coh(facesdata, EEG.srate, facesbrkpnts);
%     eyesopen_coh = coh(eyesopendata, EEG.srate, eyesopenbrkpnts);
%     eyesclosed_coh = coh(eyescloseddata, EEG.srate, eyesclosedbrkpnts);
%     hapm_coh = coh(hapmdata, EEG.srate, hapmbrkpnts);
%     joym_coh = coh(joymdata, EEG.srate, joymbrkpnts);
%     sadm_coh = coh(sadmdata, EEG.srate, sadmbrkpnts);
%     feam_coh = coh(feamdata, EEG.srate, feambrkpnts);
%     hapyface_coh = coh(hapyfaceddata, EEG.srate, hapyfacebrkpnts);
%     angyface_coh = coh(angyfacedata, EEG.srate, angyfacebrkpnts);
%     neutface_coh = coh(neutfacedata, EEG.srate, neutfacebrkpnts);
%     fearface_coh = coh(fearfacedata, EEG.srate, fearfacebrkpnts);
end
    
    

