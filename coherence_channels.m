% compute spectral coherence among 2 pairs of channels
% coherence = |Sxy|^2/(Sxx)*(Syy)

% first rename variables
srate = ALLEEG.srate
windows = floor(ALLEEG.pnts/ALLEEG.srate)

% call channel 10 X, channel 11 Y, channel 120 Z
X = EEG.data(10, :)
Y = EEG.data(11, :)
Z = EEG.data(120, :)

% generate matrix of zeros to store PSDX, PSDY, PSDZ, CSDXY, CSDXZ
Sxx = zeros(windows, srate);
Syy = zeros(windows, srate);
Sxy = zeros(windows, srate);
Sxz = zeros(windows, srate);

% loop
for i = 1:windows
    Sxx(i, :) = (abs(fft(X(1 + srate*(i-1) : srate*i)))).^2;
    Syy(i, :) = (abs(fft(Y(1 + srate*(i-1) : srate*i)))).^2;
    Szz(i, :) = (abs(fft(Z(1 + srate*(i-1) : srate*i)))).^2;
    Sxy(i, :) = fft(X(1 + srate*(i-1) : srate*i)).*conj(fft(Y(1 + srate*(i-1) : srate*i)));
    Sxz(i, :) = fft(X(1 + srate*(i-1) : srate*i)).*conj(fft(Z(1 + srate*(i-1) : srate*i)));
end

% average over 1894 epochs
Sxx = mean(Sxx);
Syy = mean(Syy);
Szz = mean(Szz);
Sxy = mean(Sxy);
Sxz = mean(Sxz);

% compute spectral coherence for both pairs of channels
% channel 10 and 11
coh1 = ((abs(Sxy)).^2)./((Sxx).*(Syy))
% channel 10 and 120
coh2 = ((abs(Sxz)).^2)./((Sxx).*(Szz))

% plot coherence for each pair
% ignore negative frequencies
coh1 = [coh1(1:srate/2)]
coh2 = [coh2(1:srate/2)]
% create frequence vector 
freq = linspace(0, srate/2, srate/2)
% channel 10 and 11
figure()
plot1 = plot(freq, coh1)
title('Coherence of Channels 10 and 11')
xlabel('Frequency')
ylabel('Coherence')
% channel 10 and 120 
figure()
plot2 = plot(freq, coh2)
title('Coherence of Channels 10 and 120')
xlabel('Frequency')
ylabel('Coherence')








