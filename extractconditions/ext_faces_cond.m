function [facesdata, facesbrkpnts] = ext_faces_cond(EEG);

% extract faces condition data

% create string vector of the types of event markers
type = string({EEG.event.type});

% search for start of condition
bgnname = 'hapy';
bgnidx = zeros(1, 2);
bgnidx(1) = find(type ==  bgnname, 1)';
typeidx = 1:length(type);
idx = find(typeidx > bgnidx(1));

endidx = zeros(1, 2);
for j = idx(1:length(idx))
    if type(j) == 'SESS'
       endidx(1) = j - 1;
       endidx(2) = length(type);
       bgnidx(2) = j + 5;
       break
    else
        endidx(1) = length(type);
        endidx = endidx(find(endidx));
        bgnidx = bgnidx(find(bgnidx));
    end
end

%  create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

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
facesdata = EEG.data(:, condition);

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
facesbrkpnts = sort([0 boundarypnts endpnts]);

end

