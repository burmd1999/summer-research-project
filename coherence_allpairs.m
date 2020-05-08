% variables
srate = ALLEEG.srate;
numchannels = ALLEEG.nbchan;
numwindows = floor(ALLEEG.pnts/ALLEEG.srate);
data = EEG.data;

% number of pairs of channels
numpairs = nchoosek(numchannels, 2);

% vector of each pair of channels
pairs = nchoosek(1:numchannels, 2);

% create matrices of zeros to store data 
PSD1 = zeros(numwindows*numchannels, srate);
PSD2 = zeros(numwindows*numchannels, srate);
PSD11 = zeros(numchannels, srate);
PSD21 = zeros(numchannels, srate);
CSD = zeros(3*numwindows, srate);
CSD1 = zeros(numchannels, srate);
COH = zeros(numchannels, srate);

% loop to calculate coherence of each pair of channels
 for i = 1:3
    for j = 1:numwindows
        PSD1(numwindows*(i-1) + j, :) = abs((fft(data(pairs(i, 1), 1 + srate*(j-1) : srate*j)))).^2;
        PSD2(numwindows*(i-1) + j, :) = abs((fft(data(pairs(i, 2), 1 + srate*(j-1) : srate*j)))).^2;
        CSD(numwindows*(i-1) + j, :) = fft(data(pairs(i, 1), (1 + srate*(j-1) : srate*j))).*conj(fft(data(pairs(i, 2), (1 + srate*(j-1) : srate*j))));
        PSD11(i, :) = mean(PSD1(numwindows*(i-1) + 1:numwindows*i, :));
        PSD21(i, :) = mean(PSD2(numwindows*(i-1) + 1:numwindows*i, :));
        CSD1(i, :) = mean(CSD(numwindows*(i-1) + 1:numwindows*i, :));
        COH(i, :) = ((abs(CSD1(i, :))).^2)./((PSD11(i, :)).*(PSD21(i, :)));
    end
end
% this works but the matrix CSD is too big for matlab to calculate CSD of all pairs. 





    


