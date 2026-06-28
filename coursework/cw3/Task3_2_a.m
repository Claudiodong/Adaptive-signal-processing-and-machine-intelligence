clc
clear
close all

L = 1500;
M = 1;
mu = 0.06;
% generate phase function
fe = zeros(L,1);
fe(1:500) = 100;
n = 501:1000;
fe(n) = 100 + (n-500)/2;
n = 1001:1500;
fe(n) = 100 + ((n-1000)/25).^(2);

% generate the phase
fs = 1000;
phase = cumsum(fe);
noise = sqrt(0.05/2)*(randn(L,1) + 1i*randn(L,1));

% signal
y = exp(1i* 2*pi/fs * phase) + noise;

% AR coefficient
[AR_coefficient] = aryule(y,1);

[h,w]=freqz(1,AR_coefficient,1024);


figure()
plot(fe)
xlabel("Time [t]",'fontsize',12);ylabel("Frequency [Hz]",'fontsize',12)
ylim([0, 500]); grid on; title("$f(n)$",'fontsize',12)


figure() % can not capture the change in the frequency 
plot(w*fs/(2*pi), 20*log10(abs(h)))
ylabel("Magnitude [dB]",'fontsize',12);xlabel("Frequency [Hz]",'fontsize',12)
title("Power Spectrum estimation",'fontsize',12)
grid on;


%% Apply the CLMS algorithm
[e,a]=CLMS(M,y,y,mu);

for i = 1:length(a)
    % Run complex-valued LMS algorithm to estimate AR coefficient aˆ1(n)
    [h ,w]= freqz(1 , [1; -conj(a(i))], 1024); % Compute power spectrum
    H(:, i) = abs(h).^2; % Store it in a matrix
end
% Remove outliers in the matrix H
medianH = 50*median(median(H));
H(H > medianH) = medianH;


figure()
[xx,yy] = meshgrid(1:L,w/pi * fs/2);
mesh(xx, yy,  H);
view(2);
colormap turbo; colorbar;
xlabel("Time [t]",'fontsize',12);ylabel("Frequency [Hz]",'fontsize',12);
title("Time-frequency spectrum",'fontsize',12)


