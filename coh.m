function [coherence, pairs] = coh(data, srate, brkpnts)

% DESCRIPTION OF FUNCTION

% The function coh(data, srate, brkpnts) calculates the coherence between each pair of channels in the EEG data. 

% Inputs: 

% data: is a matrix containing the EEG data with dimensions (number of channels) x (total number of data points).

% srate: is an integer whose value is the sampling rate of the data collected. 

% brkpnts: is a row vector whose entries are the breakpoints in the data. Note
% that the first entry of the brkpnts vector should be 0, followed by the
% breakpoints within the data, and the last entry should be the total
% number of points in the data.

% Outputs:

% coherence: is a matrix with dimensions (number of channels choose 2) x (srate).

% pairs: is a matrix with dimensions (number of channels choose 2) x 2, where the n^th row of the coherence matrix is the coherence between the channels defined by the n^th row of the pairs matrix.

% FUNCTION CODE

% number of channels
numchannels = size(data, 1);

% hann window function
w = hann(srate)';

% overlap
overlap = floor(srate/2);

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
coherence = zeros(numpairs, srate);

% loop to calculate coherence of each pair of channels
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
    coherence(i, :) = ((abs(CSD)).^2)./(PSD1.*(PSD2));
end

end
