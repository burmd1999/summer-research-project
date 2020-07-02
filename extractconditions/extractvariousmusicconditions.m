function [diffmusicdata, diffmusicbrkpnts] = ext_diff_music_cond(EEG)

% The function ext_diff_music_cond extracts the four different music
% conditions: happy music, joy music, sad music, and fear music from the EEG data set.
% Input EEG is a given EEG data structure including field types srate, event, and data.
% Outputs: 
% diffmusicdata is a 4x1 cell array where each cell is the EEG data matrix of each music condition - first cell is happy, second is joy,
% third is sad, and fourth is fear.
% diffmusicbrkpnts is a 4x1 cell array where each cell is the breakpoint
% vector of each music condition - again following the same order as
% diffmusicdata.

bgnname = ["hapm", "joym", "sadm", "feam"];

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% find indices of the beginning of each music condition
bgnidx = length(bgnname);
for i = 1:length(bgnname)
    bgnidx(i) = find(type == bgnname(i));
end

% latencies of start and end of each music cond
bgncond = floor(latency(bgnidx));
endcond = bgncond + 60*EEG.srate + 1;

% create a cell array where each array is the indices of the different
% music conditions
condition = cell(length(bgncond), 1);
for i = 1:length(bgncond)
    condition{i} = bgncond(i):endcond(i);
end

% boundaries in data 
b = find(type == 'boundary');
boundary = floor(latency(b));

% find boundary points in each music condition
boundarypnts = cell(size(condition, 1), 1);
for i = 1:length(condition)
    boundarypnts{i} = find(ismember(condition{i},boundary));
end

% endpoints of each music condition
endpnt = length(condition{1});

% breakpoints of each music condition
diffmusicbrkpnts = cell(length(condition), 1);
for i = 1:length(condition)
    diffmusicbrkpnts{i} = sort([0 boundarypnts{i} endpnt]);
end

% data
diffmusicdata = cell(length(condition), 1);
for i = 1:length(condition)
    diffmusicdata{i} = EEG.data(:, condition{i});
end

end







    
    
    
    
    
    
