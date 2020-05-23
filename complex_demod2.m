%% create signal
% sampling frequency
fs = 1e2; 
% sampling period
T = 1/fs; 
% time vector
t = [0:T:2];
% frequencies of sinusoidal signal
f_1 = 5; 
f_2 = 15;
% phase vectors
phi_1 = [zeros(1, 101) (pi/4)*ones(1, 100)]; 
phi_2 = [(pi/2)*ones(1, 101) zeros(1, 100)]; 
% sinusoidal signal with random noise
x = cos(2*pi*f_1.*t + phi_1) + cos(2*pi*f_2.*t + phi_2) + randn(size(t))/10; 

%% complex demodulation for first frequency
x_1 = x.*exp(-i*2*pi*f_1.*t);

%% low-pass filter
y_1 = lowpass(x_1, 0.2, fs);

%% phase 1
phase = angle(y_1);
figure()
plot(t, phase)
title('Phase Plot of 5 Hz Component')
xlabel('Time')
ylabel('Phase')

%% complex demodulation for second frequency
x_2 = x.*exp(-i*2*pi*f_2.*t);

%% low-pass filter
y_2 = lowpass(x_2, 0.2, fs);

%% phase 2
phase = angle(y_2);
figure()
plot(t, phase)
title('Phase Plot of 15 Hz Component')
xlabel('Time')
ylabel('Phase')





