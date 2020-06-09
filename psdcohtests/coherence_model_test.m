% time, sampling rate, windows
pnts = 10*ALLEEG.pnts;
srate = ALLEEG.srate;
windows = floor(10*ALLEEG.pnts/ALLEEG.srate);

% generate signals x and y
y = zeros(1, pnts);
x = zeros(1, pnts);
sigma = 1;
mu = 0;
theta = 0.5;
phi = 0.25;
epsilon = normrnd(mu, sigma, pnts, 1);
delta = normrnd(mu, sigma, pnts, 1);
% loop
for t = 2:pnts
    y(t) = theta*y(t-1) + delta(t);
    x(t)= phi*x(t-1) + phi*y(t-1) + epsilon(t);
end

% generate matrix of zeros to store PSDX, PSDY, CSDXY
Sxx = zeros(windows, srate);
Syy = zeros(windows, srate);
Sxy = zeros(windows, srate);

% loop to compute spectral densities for each window
for i = 1:windows
    Sxx(i, :) = (abs(fft(x(1 + srate*(i-1) : srate*i)))).^2;
    Syy(i, :) = (abs(fft(y(1 + srate*(i-1) : srate*i)))).^2;
    Sxy(i, :) = fft(x(1 + srate*(i-1) : srate*i)).*conj(fft(y(1 + srate*(i-1) : srate*i)));
end

% average over 1894 windows
Sxx = mean(Sxx);
Syy = mean(Syy);
Sxy = mean(Sxy);

% compute coherence 
 coh = ((abs(Sxy)).^2)./((Sxx).*(Syy));

% plot coherence
% ignore negative frequencies
coh = [coh((srate/2 + 1):srate) ; coh(1:srate/2)]
% create frequency vector
freq = linspace(0, srate/2, srate/2)
figure()
plot1 = plot(freq, coh)

% plot derived coherence function
coh2 = 1./(21 - 16*cos(2*pi*freq))
figure()
plot2 = plot(freq, coh2)



