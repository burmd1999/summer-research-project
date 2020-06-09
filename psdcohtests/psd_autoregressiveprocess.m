% generate autoregressive process
time = 1000;
y = ones(time, 1);
y(1) = 0;
sigma = 0.01;
mu_epsilon = 0;
theta = 0.95;
epsilon = normrnd(mu_epsilon, sigma, time, 1);
% loop
for t = 2:1000
    y(t)= theta*y(t-1) + epsilon(t);
end

% plot of autoregressive process 
figure
plot(y);
title('AR(1)');
xlabel('t');
ylabel('y(t)')

% compute discrete fourier transform of autoregressive process
X = fft(y)

% absolute value of fft - convolution theorem
plot(abs(X))

% rearrange X 
X1 = [X(500:1000); X(1:499)]

% plot absolute value of X1
plot(linspace(-2,2,1000), abs(X1))
xt = get(gca, 'XTick'); 
set(gca, 'XTick', xt, 'XTickLabel', xt/500)

% plot true FT of autoregressive process
fx = @(x) 1/(1-1.9*cos(x)+0.9025)
f3 = figure;
fplot(fx)





