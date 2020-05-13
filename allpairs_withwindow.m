%% variables
srate = 512;
numchannels = 128;
numwindows = 1894;
data = EEG.data;

%% hann window function
L = 512;
w = hann(L)';

%% pairs of channels
% number of pairs of channels
numpairs = nchoosek(numchannels, 2);
% vector of each pair of channels
pairs = nchoosek(1:numchannels, 2);

%% create matrices of zeros to store coherence data 
COH_w = zeros(numpairs, srate);

%% loop to calculate coherence of each pair
for i = 1:numpairs
    PSD1 = zeros(1, srate);
    PSD2 = zeros(1, srate);
    CSD = zeros(1, srate);
    for j = 1:numwindows
        PSD1 = PSD1 + ((abs(fft((data(pairs(i, 1), 1 + srate*(j-1):srate*j)).*w))).^2)./numwindows;
        PSD2 = PSD2 + ((abs(fft((data(pairs(i, 2), 1 + srate*(j-1):srate*j)).*w))).^2)./numwindows;
        CSD = CSD + (fft((data(pairs(i, 1), 1 + srate*(j-1):srate*j)).*w).*conj(fft((data(pairs(i, 2), 1 + srate*(j-1):srate*j)).*w)))./numwindows;
        COH_w(i, :) = ((abs(CSD)).^2)./(PSD1.*(PSD2));
    end
end

%% plot data
% rearrange coherence vectors- get rid of negative frequencies
COH1_w = COH_w(:, 1:srate/2);
% frequency vector
freq = linspace(0, srate/2, srate/2);
figure()
hold on
for i = 1:numpairs
    plot(freq, COH1_w(i, :));
end 