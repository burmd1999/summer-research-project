function [eyesopendata, eyesopenbrkpnts] = ext_eopen_cond(EEG)

% DESCRIPTION OF FUNCTION 

% The function ext_eopen_cond extracts the data and breakpoints
% pertaining to the eyes open
% condition in the EEG data.

% Input:
% EEG is a 1x1 structure with fields event, srate, and latency in
% particular.

% Outputs:
% eyesopendata is a data matrix with dimensions (number of channels) x
% (number of data points in eyes closed condition)
% eyesopenbrkpnts is a row vector whose entries are the breakpoints in the
% eyes open condition. Note that the first entry is 0, followed by the
% boundary points within the eyes open condition, and the last entry is the
% total number of data points in the eyes open condition. 

% FUNCTION 

% names of start and end of eyes open condition
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
boundarypnts = find(ismember(condition,boundarypnts));

% make boundary points between endcond and bgncond 
endpnts = zeros(1, length(endcond));
for i = 1:length(endcond)
    endpnts(i) = find(condition == endcond(i));
end

% final breakpoints vector 
eyesopenbrkpnts = sort([0 boundarypnts endpnts]);

end
