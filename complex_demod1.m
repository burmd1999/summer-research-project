%% create sinuosoidal signal 
% sampling frequency
fs = 1e3; 
% sampling period
T = 1/fs; 
% time vector
t = [0:T:2];
% frequency of sinusoidal signal
f = 50; 
% phase vector
phi = [zeros(1, 1001) (pi/4)*ones(1, 1000)]; 
% sinusoidal signal with random noise
x = cos(2*pi*f.*t + phi) + randn(size(t))/10; 

%% plot signal
figure()
plot(t, x)
title('50 Hz Sinusoidal Signal with Random Normal Noise')
xlabel('Time')

%% complex demodulation
x_1 = x.*exp(-i*2*pi*f.*t);

%% low-pass filter
y = lowpass(x_1, f, fs)

%% phase 
phase = angle(y);
figure()
plot(t, phase)
title('Phase Plot')
xlabel('Time')
ylabel('Phase')







