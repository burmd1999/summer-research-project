function [hapyfacedata, hapyfacebrkpnts] = ext_hapyface_cond(EEG)

% extract hapy face condition

bgnname = 'hapy';

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% extract beginning of each hapy segment
bgnidx = find(type == bgnname);
bgncond = floor(latency(bgnidx));

% extract end of each hapy segment - 2 seconds after 'hapy' marker
endcond = bgncond + 2*EEG.srate + 1;

% create a vector of the indices of the desired condition
condition = cell(1, length(bgncond));
for i = 1:length(bgncond)
     condition{i} = bgncond(i):endcond(i);
end
condition = cell2mat(condition);

% extract data from EEG 
hapyfacedata = EEG.data(condition);

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
hapyfacebrkpnts = sort([0 boundarypnts endpnts]);

end



    
    
    
    


