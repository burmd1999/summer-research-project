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
numwindows = floor((numpnts - srate)/overlap) + 1;

%% pairs of channels
% number of pairs of channels
numpairs = nchoosek(numchannels, 2);
% vector of each pair of channels
pairs = nchoosek(1:numchannels, 2);

%% create matrices of zeros to store coherence data 
COH_w_o = zeros(numpairs, srate);

%% loop to calculate coherence of each pair
for i = 1:numpairs
    PSD1 = zeros(1, srate);
    PSD2 = zeros(1, srate);
    CSD = zeros(1, srate);
    for j = 1:numwindows
        PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w))).^2)./numwindows;
        PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w))).^2)./numwindows;
        CSD = CSD + (fft((data(pairs(i, 1), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w).*conj(fft((data(pairs(i, 2), 1 + overlap*(j-1):(srate + overlap*(j-1)))).*w)))./numwindows;
        COH_w_o(i, :) = ((abs(CSD)).^2)./(PSD1.*(PSD2));
    end
end

%% plot data
% rearrange coherence vectors--get rid of negative frequencies
COH1_w_o = COH_w_o(:, 1:srate/2);
% frequency vector
freq = linspace(0, srate/2, srate/2);
figure()
hold on
for i = 1:numpairs
    plot(freq, COH1_w_o(i, :));
end 