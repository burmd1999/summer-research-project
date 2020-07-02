function [diff_music_data, diff_music_brkpnts] = ext_diff_music_cond(EEG)

% The function ext_diff_music_cond extracts the four different faces
% conditions: happy music, joy music, sad music, and fearful music from the EEG data set.
% Input EEG is a given EEG data structure including field types srate, event, and data.
% Outputs: 
% diff_music_data is a 4x1 cell array where each cell is the EEG data matrix of each faces condition - first cell is happy, second is joy,
% third is sad, and fourth is fear.
% diff_music_brkpnts is a 4x1 cell array where each cell is the breakpoint
% vector of each music condition - again following the same order as
% diff_music_data.

bgnname = ["hapm", "joym", "sadm", "feam"];

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% find indices of the beginning of each music condition
bgnidx = zeros(1, length(bgnname));
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
diff_music_brkpnts = cell(length(condition), 1);
for i = 1:length(condition)
    diff_music_brkpnts{i} = sort([0 boundarypnts{i} endpnt]);
end

% data
diff_music_data = cell(length(condition), 1);
for i = 1:length(condition)
    diff_music_data{i} = EEG.data(:, condition{i});
end

end







    
    
    
    
    
    
