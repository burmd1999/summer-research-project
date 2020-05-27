function coherence = coh(data, srate, numchannels, brkpnts)

% hann window function
L = srate;
w = hann(L)';

% overlap
overlap = srate/2;

% break points
brkpnts = [0 900 21357 206110 969958];
% size of brkpnts vector
s = size(brkpnts, 2);

% windows
k = 2:s; 
numwindows = sum(floor((brkpnts(k) - brkpnts(k-1) - srate)/overlap) + 1);

% pairs of channels
% number of pairs of channels
numpairs = nchoosek(numchannels, 2);
% vector of each pair of channels
pairs = nchoosek(1:numchannels, 2);

% create matrices of zeros to store coherence data 
COH = zeros(numpairs, srate);

% loop to calculate coherence of each pair
for i = 1:numpairs 
    PSD1 = zeros(1, srate);
    PSD2 = zeros(1, srate);
    CSD = zeros(1, srate);
    for k = 2:s
        for j = 1:floor((brkpnts(k) - brkpnts(k - 1) - srate)/overlap) + 1
            PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), brkpnts(k - 1) + 1 + overlap*(j - 1):(brkpnts(k - 1) + srate + overlap*(j - 1)))).*w))).^2)./numwindows;
            PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), brkpnts(k - 1) + 1 + overlap*(j - 1):(brkpnts(k - 1) + srate + overlap*(j - 1)))).*w))).^2)./numwindows;
            CSD = CSD + (fft((data(pairs(i, 1), brkpnts(k - 1) + 1 + overlap*(j - 1):(brkpnts(k - 1) + srate + overlap*(j - 1)))).*w).*conj(fft((data(pairs(i, 2), brkpnts(k - 1) + 1 + overlap*(j - 1):(brkpnts(k - 1) + srate + overlap*(j - 1)))).*w)))./numwindows;
        end
    end
    COH(i, :) = ((abs(CSD)).^2)./(PSD1.*(PSD2));
end

coherence = [COH]
end
