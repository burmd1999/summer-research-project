

bgnname = ["hapy", "fear", "neut", "angy"];

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% find indices of the beginning of each face condition
bgnidx = length(bgnname);
for i = 1:length(bgnname)
    bgnidx(i) = find(type == bgnname(i));
end

% latencies of start and end of each music cond
bgncond = floor(latency(bgnidx));
endcond = bgncond + 2*EEG.srate + 1;

% create a cell array where each array is the indices of the different face conditions
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

% endpoints of each face condition
endpnt = length(condition{1});

% breakpoints of each face condition
diff_face_brkpnts = cell(length(condition), 1);
for i = 1:length(condition)
    diff_face_brkpnts{i} = sort([0 boundarypnts{i} endpnt]);
end


