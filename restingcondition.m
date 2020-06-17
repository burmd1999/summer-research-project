% data, sampling rate
data = EEG.data; 
srate = EEG.srate;

% event indices of resting condition
bgnidx = 9
endidx = 31

% create vector of the latencies of the event markers
latency = cell2mat({EEG.event.latency});

% latencies of beginning & end of epoch
bgnepoch = floor(latency(bgnidx));
endepoch = floor(latency(endidx));

% extract epoch from event structure
epochevent = EEG.event(bgnidx:endidx);

% find boundaries contained within epoch
epochtype = string({epochevent.type});
b = find(epochtype == 'boundary');
eventlatency = cell2mat({epochevent.latency});
boundarypnts = [floor(eventlatency(b))];

% make breakpoints vector 
brkpnts = [(bgnepoch - 1) boundarypnts endepoch];

% coherence of resting condition
coh_resting = coh(data, srate, brkpnts);





