% data, sampling rate
data = EEG.data; 
srate = EEG.srate;

% create string vector of the types of event markers
type = string({EEG.event.type});

% names of the markers signifying beginning and end of epoch of interest
bgnname = 'eopn';
endname = 'clos';

% indices of the beginning and end of each epoch
bgnidx = find(type ==  bgnname);
endidx = find(type == endname);

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% create cell array to store each segment of eyes open
s = size(bgnidx, 2);
eyesopendata = cell(1, s);

for t = 1:s
    
    % latencies of beginning & end of epoch
    bgnepoch = floor(latency(bgnidx(t)));
    endepoch = floor(latency(endidx(t)));
    % extract epoch from event structure
    epochevent = EEG.event(bgnidx(t):endidx(t));
    % find boundaries contained within epoch
    epochtype = string({epochevent.type});
    b = find(epochtype == 'boundary');
    eventlatency = cell2mat({epochevent.latency});
    boundarypnts = [floor(eventlatency(b))];
    % make breakpoints vector 
    brkpnts = [(bgnepoch - 1) boundarypnts endepoch];
    % store coherence data in cell array 
    eyesopendata{t} = coh(data, srate, brkpnts);
    
end
%%
% average 3 segments
t = 1:s
eyesopen_coh = sum(eyesopendata{t})./3 % this does not work

  
    
    
    

