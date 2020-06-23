function [data, brkpnts] = extcond(EEG, bgnname, endname)

% DESCRIPTION
% extcond extracts the EEG data pertaining to a time-locked condition and
% calculates the corresponding vector of break points in the data. 
% EEG is a 1x1 structure containing EEG data for a given data set.
% bgnname is the name of the event marker that indicates the beginning of the desired condition. 
% endname is the name of the event marker that indicates the end of the desired condition.
% Both bgnname and endname should be entered as character values, surrounded by single quotes ' '.
% Output:
% data is a matrix of the extracted EEG data pertaining to this condition, with dimensions (number of channels) x (number of data points in desired condition).
% brkpnts is a row vector vector indicating all of the breakpoints in the
% data, including the boundary points within the condition given by the
% EEG.event.type field, and the points that indicate the end of one segment
% of the condition before the next segnment begins.
% Note that the first entry in the brkpnts vector is 0, and the last entry is the total number of
% data points.


% create string vector of the types of event markers
type = string({EEG.event.type});

% search for start and end of condition
bgnidx = find(type ==  bgnname)';
endidx = find(type == endname)';

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% create vectors of the beginning points of condition and end points of condition
bgncond = floor(latency(bgnidx));
endcond = floor(latency(endidx));

% create a vector of the indices of the desired condition
condition = [];
for i = 1:length(bgncond)
    condition = [condition bgncond(i):endcond(i)];
end

% extract data from EEG 
data = EEG.data(condition);

% search for boundary points within the condition
b = find(type == 'boundary');
boundarypnts = [floor(latency(b))];
boundarypnts = find(ismember(condition,boundarypnts));

% create vector boundary points between each segment
endpnts = zeros(1, length(endcond));
for i = 1:length(endcond)
    endpnts(i) = find(condition == endcond(i));
end

% final breakpoints vector 
brkpnts = sort([0 boundarypnts endpnts]);

end