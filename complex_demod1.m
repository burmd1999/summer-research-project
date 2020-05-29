%% create sinuosoidal signal 
% sampling frequency
fs = 1e2; 
% sampling period
T = 1/fs; 
% time vector
t = [0:T:2];
% frequency of sinusoidal signal
f = 5; 
% phase vector
phi = [zeros(1, 101) (pi/4)*ones(1, 100)]; 
% sinusoidal signal with random noise
x = cos(2*pi*f.*t + phi) + randn(size(t))/10; 

%% plot signal
figure()
plot(t, x)
title('5 Hz Monocomponent Sinusoidal Signal with Random Normal Noise')
xlabel('Time')

%% complex demodulation
x_1 = x.*exp(-i*2*pi*f.*t);

%% low-pass filter
y = lowpass(x_1, 0.1, fs)

%% phase 
phase = angle(y);
figure()
plot(t, phase)
title('Phase Plot for Monocomponent 5 Hz Signal')
xlabel('Time')
ylabel('Phase')







