function [eyesopendata, eyesopenbrkpnts] = ext_eopen_cond(EEG)

% extract eyes open condition 

bgnname = 'eopn';
endname = 'clos';

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% search for start and end of condition
bgnidx = find(type ==  bgnname)';
endidx = find(type == endname)';

% create vectors of the beginning points of condition and end points of condition
bgncond = floor(latency(bgnidx));
endcond = floor(latency(endidx));

% create a vector of the indices of the desired condition
condition = cell(1, length(bgncond));
for i = 1:length(bgncond)
    condition{i} = bgncond(i):endcond(i);
end
condition = cell2mat(condition);

% extract data from EEG 
eyesopendata = EEG.data(:, condition);

% search for boundary points within the condition
b = find(type == 'boundary');
boundarypnts = floor(latency(b));
boundarypnts = condition(find(ismember(condition,boundarypnts)));

% create vector of boundary points between each segment
condition = cell(1, length(bgncond));
for i = 1:length(bgncond)
    condition{i} = bgncond(i):endcond(i);
end
condition = cell2mat(condition);

% final breakpoints vector 
eyesopenbrkpnts = sort([0 boundarypnts endpnts]);

end
