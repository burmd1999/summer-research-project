% generate signals x and y
time = 1000;
srate = 1;
% create vectors 
y = zeros(time, 1);
x = zeros(time, 1);
sigma = 1;
mu = 0;
theta = 0.5;
phi = 0.25;
epsilon = normrnd(mu, sigma, time, 1);
delta = normrnd(mu, sigma, time, 1);
% loop
for t = 2:1000
    y(t) = theta*y(t-1) + delta(t);
    x(t)= phi*x(t-1) + phi*y(t-1) + epsilon(t);
end

% compute spectral densities
Sxx = abs(fft(x)).^2;
Syy = abs(fft(y)).^2;
Sxy = fft(x).*conj(fft(y));

% compute coherence 
coh = ((abs(Sxy)).^2)./((Sxx).*(Syy));

% plot coherence
coh = [coh(1:time/2)]
% create frequency vector
freq = linspace(0, time/2, time/2)
figure()
plot1 = plot(freq,coh)

% plot derived coherence function
coh2 = 1./(21-16*cos(freq))
figure()
plot2 = plot(freq, coh2)



