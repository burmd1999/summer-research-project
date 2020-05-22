%% variables
srate = 512;
numchannels = 128;
data = EEG.data;
numpnts = 969958

%% hann window function
L = 512;
w = hann(L)';

%% overlap
overlap = srate/2;

%% break points
brkpnts = [900 21357 206110];

%% windows
numwindows = (floor((brkpnts(1) - srate)/overlap) + 1) + (floor((brkpnts(2) - brkpnts(1) - srate)/overlap) + 1) + (floor((brkpnts(3) - brkpnts(2) - srate)/overlap) + 1) + (floor((numpnts - brkpnts(3) - srate)/overlap) + 1);
numwindows_1 = (floor((brkpnts(1) - srate)/overlap) + 1);
numwindows_2 = (floor((brkpnts(2) - brkpnts(1) - srate)/overlap) + 1);
numwindows_3 = (floor((brkpnts(3) - brkpnts(2) - srate)/overlap) + 1);
numwindows_4 = (floor((numpnts - brkpnts(3) - srate)/overlap) + 1);

%% pairs of channels
% number of pairs of channels
numpairs = nchoosek(numchannels, 2);
% vector of each pair of channels
pairs = nchoosek(1:numchannels, 2);

%% create matrices of zeros to store coherence data 
COH_brkpnts = zeros(numpairs, srate);

%% loop to calculate coherence of each pair
for i = 1:numpairs 
    PSD1 = zeros(1, srate);
    PSD2 = zeros(1, srate);
    CSD = zeros(1, srate);
    for j = 1:numwindows_1
        PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        CSD = CSD + (fft((data(pairs(i, 1), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w).*conj(fft((data(pairs(i, 2), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w)))./numwindows2;
    end
    for j = 1:numwindows_2
        PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), brkpnts(1) + 1 + overlap*(j-1):(brkpnts(1) + srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), brkpnts(1) + 1 + overlap*(j-1):(brkpnts(1) + srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        CSD = CSD + (fft((data(pairs(i, 1), brkpnts(1) + 1 + overlap*(j-1):(brkpnts(1) + srate + overlap*(j-1)))).*w).*conj(fft((data(pairs(i, 2), brkpnts(1) + 1 + overlap*(j-1):(brkpnts(1) + srate + overlap*(j-1)))).*w)))./numwindows2;
    end
    for j = 1:numwindows_3
        PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), brkpnts(2) + 1 + overlap*(j-1):(brkpnts(2) + srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), brkpnts(2) + 1 + overlap*(j-1):(brkpnts(2) + srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        CSD = CSD + (fft((data(pairs(i, 1), brkpnts(2) + 1 + overlap*(j-1):(brkpnts(2) + srate + overlap*(j-1)))).*w).*conj(fft((data(pairs(i, 2), brkpnts(2) + 1 + overlap*(j-1):(brkpnts(2) + srate + overlap*(j-1)))).*w)))./numwindows2;
    end     
    for j = 1:numwindows_4
        PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), brkpnts(3) + 1 + overlap*(j-1):(brkpnts(3) + srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), brkpnts(3) + 1 + overlap*(j-1):(brkpnts(3) + srate + overlap*(j-1)))).*w))).^2)./numwindows2;
        CSD = CSD + (fft((data(pairs(i, 1), brkpnts(3) + 1 + overlap*(j-1):(brkpnts(3) + srate + overlap*(j-1)))).*w).*conj(fft((data(pairs(i, 2), brkpnts(3) + 1 + overlap*(j-1):(brkpnts(3) + srate + overlap*(j-1)))).*w)))./numwindows2;
    end
    COH_brkpnts(i, :) = ((abs(CSD)).^2)./(PSD1.*(PSD2));
end


