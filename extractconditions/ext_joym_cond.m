function [joymdata, joymbrkpnts] = ext_joym_cond(EEG)

% extract joy music condition

bgnname = 'joym'

% create string vector of the types of event markers
type = string({EEG.event.type});

% search for start of condition
bgnidx = find(type == bgnname);

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% create vectors of the beginning points of condition and end points of condition
bgncond = floor(latency(bgnidx));
endcond = bgncond(1) + 60*EEG.srate + 1;

% create a vector of the indices of the desired condition
condition = cell(1, length(bgncond));
for i = 1:length(bgncond)
    condition{i} = bgncond(i):endcond(i);
end
condition = cell2mat(condition);

% extract data from EEG 
joymdata = EEG.data(:, condition);

% search for boundary points within the condition
b = find(type == 'boundary');
boundarypnts = [floor(latency(b))];
boundarypnts = condition(find(ismember(condition,boundarypnts)));

% make boundary points between endcond and bgncond 
endpnts = zeros(1, length(endcond));
for i = 1:length(endcond)
    endpnts(i) = find(condition == endcond(i));
end

% final breakpoints vector 
joymbrkpnts = sort([0 boundarypnts endpnts]);

end

