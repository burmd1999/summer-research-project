function [restingdata, restingbrkpnts] = ext_rest_cond(EEG)

% DESCRIPTION OF FUNCTION 

% The function ext_rest_cond extracts the data and breakpoints pertaining to the resting
% condition in the EEG data.

% Input:
% EEG is a 1x1 structure with fields event, srate, and latency in
% particular.

% Outputs:
% restingdata is a data matrix with dimensions (number of channels) x
% (number of data points in resting condition)
% restingbrkpnts is a row vector whose entries are the breakpoints in the
% resting condition. Note that the first entry is 0, followed by the
% boundary points within the resting condition, and the last entry is the
% total number of data points in the resting condition. 

% FUNCTION 

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% search for start of resting condition
bgnname = 'open';
bgnidx = find(type ==  bgnname)';
bgnidx = bgnidx(1);

% search for end of resting condition
endname = 'ecld';
endidx = find(type == endname)';
endidx = endidx(length(endidx));

% create vectors of the beginning data points of condition and end points of condition
bgncond = floor(latency(bgnidx));
endcond = floor(latency(endidx)) + 60*EEG.srate + 1;

% create a vector of the indices of the resting condition
condition = bgncond:endcond;

% extract resting data from EEG 
restingdata = EEG.data(:, condition);

% search for boundary points within the resting condition
b = find(type == 'boundary');
boundarypnts = [floor(latency(b))];
boundarypnts = find(ismember(condition,boundarypnts));

% end point of data 
endpnt = length(condition);

% final breakpoints vector 
restingbrkpnts = sort([0 boundarypnts endpnt]);

end


    
    
    
    
