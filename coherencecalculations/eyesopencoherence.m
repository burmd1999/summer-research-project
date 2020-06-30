% extract eyes open data and compute coherence
[data, brkpnts] = extcond(EEG, 'eopn', 'clos');
srate = EEG.srate;
coh_eopen = coh(data, srate, brkpnts);
save('eyesopen301.mat', 'coh_eopen') 


