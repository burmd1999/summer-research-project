function [eyescloseddata, eyesclosedbrkpnts] = ext_eclosed_cond(EEG)

% extract eyes closed condition

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% search for start of condition
bgnname = 'ecld';
bgnidx = find(type == bgnname);

% search for end of condition
endname = 'open';
endidx = zeros(1, length(bgnidx));
for i = 1:length(bgnidx)
    type = string({EEG.event.type});
    typeidx = 1:length(type);
    idx = find(typeidx > bgnidx(i));
    for j = idx(1:length(idx))
        if type(j) == endname
           endidx(i) = j;
           break
        end
    end        
end
    
% create vectors of the beginning points of condition and end points of condition
bgncond = floor(latency(bgnidx));

if endidx(length(endidx)) == 0
   endcond = [floor(latency(endidx(1:length(endidx) - 1))) (bgncond(length(bgncond)) + 60*EEG.srate + 1)];
else
   endcond = floor(latency(endidx));
end
 
% create a vector of the indices of the desired condition
condition = cell(1, length(bgncond));
for i = 1:length(bgncond)
     condition{i} = bgncond(i):endcond(i);
end
condition = cell2mat(condition);

% extract data from EEG 
eyescloseddata = EEG.data(:, condition);

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
eyesclosedbrkpnts = sort([0 boundarypnts endpnts]);

end
