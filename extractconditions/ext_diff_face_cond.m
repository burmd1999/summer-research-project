%function [happyfacedata, happyfacebrkpnts, fearfacedata, fearfacebrkpnts, neutfacedata, neutfacebrkpnts, angryfacedata, angryfacebrkpnts] = ext_diff_face_cond(EEG)

% function [diff_face_data, diff_face_brkpnts] = ext_diff_face_cond(EEG)

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

length_bgnidx = cell(length(bgnidx), 1);
for i = 1:length(bgnidx)
    j = 2:length(bgnidx{i});
    length_bgnidx{i} = (latency(bgnidx{i}(j)) - latency(bgnidx{i}(j - 1)) - 1)/EEG.srate;
end
    
for i = 1:length(length_bgnidx)
    rm_bgnidx = find(length_bgnidx{i} <= 2)
    bgnidx{i}(rm_bgnidx) = []
end

% latencies of start and end of each face condition
bgncond = cell(length(bgnidx), 1);
for i = 1:length(bgnidx)
    bgncond{i} = floor(latency(bgnidx{i}));
end

endcond = cell(length(bgncond), 1);
for i = 1:length(bgncond)
    endcond{i} = bgncond{i} + 2*EEG.srate + 1;
end

condition = cell(length(bgncond), 1);
segment_length = length(bgncond{1}(1):endcond{1}(1));
for i = 1:length(condition)
    condition{i} = zeros(1, length(bgncond{i})*segment_length);
    for j = 1:length(bgncond{i})
        condition{i}((1 + (j - 1)*segment_length):(j*segment_length)) = bgncond{i}(j):endcond{i}(j);
    end
end

for i = 1:length(condition)
    rm = find(condition{i} > length(EEG.data), 1);
    if ~isempty(rm)
    condition{i} = condition{i}(1:rm - 1);
    end
end

% boundaries in data 
b = find(type == 'boundary');
boundary = floor(latency(b));

% find boundary points in each face condition
boundarypnts = cell(length(condition), 1);
for i = 1:length(condition)
    boundarypnts{i} = find(ismember(condition{i},boundary));
end

for i = 1:length(endcond)
    rm = find(endcond{i} > length(EEG.data), 1);
    if ~isempty(rm)
        endcond{i} = endcond{i}(1:rm - 1);
    end
end

% make boundary points between endcond and bgncond 
endpnts = cell(length(condition), 1);
for i = 1
    endpnts{i} = zeros(1, length(endcond{i}));
    for j = 1:length(endpnts{i})
        endpnts{i}(j) = find(condition{i} == endcond{i}(j));
    end
end

% breakpoints of each face condition
diff_face_brkpnts = cell(length(condition), 1);
for i = 1:length(condition)
    diff_face_brkpnts{i} = sort([0 boundarypnts{i} endpnts{i}]);
end

% data
diff_face_data = cell(length(condition), 1);
for i = 1:length(condition)
    diff_face_data{i} = EEG.data(:, condition{i});
end

% % data of each diff face
% % happyfacedata = EEG.data(:, condition{1});
% % fearfacedata = EEG.data(:, condition{2});
% % neutfacedata = EEG.data(:, condition{3});
% % angryfacedata = EEG.data(:, condition{4});
% % 
% % % breakpoints of each diff face
% % happyfacebrkpnts = sort([0 boundarypnts{1} endpnts{1}]);
% % fearfacebrkpnts = sort([0 boundarypnts{2} endpnts{2}]);
% % neutfacebrkpnts = sort([0 boundarypnts{3} endpnts{3}]);
% % angryfacebrkpnts = sort([0 boundarypnts{4} endpnts{4}]);
% 
% % end
