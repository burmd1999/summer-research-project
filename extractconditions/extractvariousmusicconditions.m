% extract various music conditions 

bgnname = ["hapm", "joym", "sadm", "feam"];

% create string vector of the types of event markers
type = string({EEG.event.type});

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

bgnidx = length(bgnname);
for i = 1:length(bgnname)
    bgnidx(i) = find(type == bgnname(i));
end

bgncond = floor(latency(bgnidx));
endcond = bgncond + 60*EEG.srate + 1;

hapmcondition = bgncond(1):endcond(1);
joymcondition = bgncond(2):endcond(2);
sadmcondition = bgncond(3):endcond(3);
feamcondition = bgncond(4):endcond(4);







    
    
    
    
    
    
