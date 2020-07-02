%function [diff_face_data, diff_face_brkpnts] = ext_diff_face_cond(EEG)

% The function ext_diff_face_cond extracts the four different faces
% conditions: happy face, fearful face, neutral face, and angry face from the EEG data set.
% Input EEG is a given EEG data structure including field types srate, event, and data.
% Outputs: 
% diff_face_data is a 4x1 cell array where each cell is the EEG data matrix of each faces condition - first cell is happy, second is fear,
% third is neutral, and fourth is angry.
% diff_face_brkpnts is a 4x1 cell array where each cell is the breakpoint
% vector of each music condition - again following the same order as
% diff_face_data.

% names of markers
bgnname = ["hapy", "fear", "neut", "angy"];

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% find indices of the beginning of each face condition
bgnidx = cell(length(bgnname), 1);
for i = 1:length(bgnname)
    bgnidx{i} = find(type == bgnname(i));
end

% latencies of start and end of each music cond
bgncond = cell(length(bgnidx), 1);
for i = 1:length(bgnidx)
    bgncond{i} = floor(latency(bgnidx{i}));
end

endcond = cell(length(bgncond), 1);
for i = 1:length(bgncond)
    endcond{i} = bgncond{i} + 2*EEG.srate + 1;
end

condition = cell(length(bgncond), 1);
for i = 1:length(bgncond)
    condition{i} = cell(1, length(bgncond{i}));
    for j = 1:length(bgncond{i})
    condition{i, j} = bgncond{i}(j):endcond{i}(j);
    end
end

% boundaries in data 
b = find(type == 'boundary');
boundary = floor(latency(b));

% find boundary points in each face condition
boundarypnts = cell(size(condition, 1), 1);
for i = 1:length(condition)
    condition_i = cell2mat(condition{i});
    boundarypnts{i} = find(ismember(condition{i},boundary));
end

    
% % bgncond = floor(latency(bgnidx));
% endcond = bgncond + 2*EEG.srate + 1;
% 
% % create a cell array where each array is the indices of the different face conditions
% condition = cell(length(bgncond), 1);
% for i = 1:length(bgncond)
%     condition{i} = bgncond(i):endcond(i);
% end
% 
% 
% % find boundary points in each music condition
% boundarypnts = cell(size(condition, 1), 1);
% for i = 1:length(condition)
%     boundarypnts{i} = find(ismember(condition{i},boundary));
% end
% 
% % endpoints of each face condition
% endpnt = length(condition{1});
% 
% % breakpoints of each face condition
% diff_face_brkpnts = cell(length(condition), 1);
% for i = 1:length(condition)
%     diff_face_brkpnts{i} = sort([0 boundarypnts{i} endpnt]);
% end
% 
% % data
% diff_face_data = cell(length(condition), 1);
% for i = 1:length(condition)
%     diff_face_data{i} = EEG.data(:, condition{i});
% end
% 
% %end
