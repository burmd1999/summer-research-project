function [musicdata, musicbrkpnts] = ext_music_cond(EEG)

% extract resting condition data

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% search for start of condition
musicidx = find(endsWith(type, 'm'))';
bgnidx = musicidx(1);
endidx = musicidx(length(musicidx));

% create vectors of the beginning points of condition and end points of condition
bgncond = floor(latency(bgnidx));
endcond = floor(latency(endidx)) + 60*EEG.srate + 1;

% create a vector of the indices of the desired condition
condition = cell(1, length(bgncond));
for i = 1:length(bgncond)
    condition{i} = bgncond(i):endcond(i);
end
condition = cell2mat(condition);

% extract data from EEG 
musicdata = EEG.data(:, condition);

% search for boundary points within the condition
b = find(type == 'boundary');
boundarypnts = [floor(latency(b))];
boundarypnts = find(ismember(condition,boundarypnts));

% make boundary points between endcond and bgncond 
endpnts = zeros(1, length(endcond));
for i = 1:length(endcond)
    endpnts(i) = find(condition == endcond(i));
end

% final breakpoints vector 
musicbrkpnts = sort([0 boundarypnts endpnts]);

end

