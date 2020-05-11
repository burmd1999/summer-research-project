%% variables
srate = ALLEEG.srate;
numchannels = ALLEEG.nbchan;
numwindows = floor(ALLEEG.pnts/ALLEEG.srate);
data = EEG.data;

%% pairs of channels
% number of pairs of channels
numpairs = nchoosek(numchannels, 2);
% vector of each pair of channels
pairs = nchoosek(1:numchannels, 2);

%% create matrices of zeros to store data 
PSD1 = zeros(numpairs, srate);
PSD2 = zeros(numpairs, srate);
CSD = zeros(numpairs, srate);
COH = zeros(numpairs, srate);

%% loop to calculate sum of PSD of windows for each channel 
% and sum of CSD of windows for each pair of channels
for i = 1:numpairs
    for j = 1:numwindows
        PSD1(i, :) = PSD1(i, :) + (abs(fft(data(pairs(i, 1), 1+ srate*(j-1):srate*j)))).^2;
        PSD2(i, :) = PSD2(i, :) + (abs(fft(data(pairs(i, 2), 1+ srate*(j-1):srate*j)))).^2;
        CSD(i, :) = CSD(i, :) + fft(data(pairs(i, 1), (1 + srate*(j-1) : srate*j))).*conj(fft(data(pairs(i, 2), (1 + srate*(j-1) : srate*j))));
    end
end

%% loop to calculate mean PSD's and CSD's
for i = 1:numpairs
    PSD1(i, :) = PSD1(i, :)./numwindows;
    PSD2(i, :) = PSD2(i, :)./numwindows;
    CSD(i, :) = CSD(i, :)./numwindows;
end

%% calculate coherence of each pair
% loop to calculate coherence of each pair
for i = 1:numpairs
    COH(i, :) = ((abs(CSD(i, :))).^2)./(PSD1(i, :).*(PSD2(i, :)));
end

%% plot data
% rearrange coherence vectors- get rid of negative frequencies
COH1 = COH(:, 1:srate/2);
% frequency vector
freq = linspace(0, srate/2, srate/2);
figure()
hold on
for i = 1:numpairs
    plot(freq, COH1(i, :));
end 