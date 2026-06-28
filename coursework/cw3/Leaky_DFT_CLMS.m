clc
clear
close all

L = 1500;
M = 1;
% generate phase function
fe = zeros(L,1);
fe(1:500) = 100;
n = 501:1000;
fe(n) = 100 + (n-500)/2;
n = 1001:1500;
fe(n) = 100 + ((n-1000)/25).^(2);

% generate the phase
fs = 1200; % minimum sampling freqeuncy is 1000 Hz since maximum frequency is 500 Hz
phase = cumsum(fe);
noise = sqrt(0.05/2)*(randn(L,1) + 1i*randn(L,1));

figure() % plot the frequency change in time 
plot(fe)
xlabel("Time [t]",'fontsize',12);ylabel("Frequency [Hz]",'fontsize',12)
ylim([0, 500]); grid on; title("$f(n)$",'fontsize',12)

% Input signal
y = exp(1i* 2*pi/fs * phase) + noise;


% DFT-CLMS
w = zeros(L,L);
gamma = 0.05;
mu = 1;
for i = 1:length(y)
    x_n = 1/L * exp(1i*(2*(i-1)*pi)/L * (0:L-1));
    y_est = w(:,i)'*x_n.';
    e = y(i) - y_est;
    w(:,i+1) = (1-mu*gamma)*w(:,i) + mu*conj(e)*x_n.';
end
w = w(:,M+1:end);
w_true = [w(1+L/2:end,:);w(1:L/2,:)]; % change to negaitve freqeuncy part
[xx,yy] = meshgrid(1:L, (-L/2+1:L/2)*(fs/L));

figure()
mesh(xx,yy,abs(w_true))
view(2);
colormap turbo;colorbar;
xlabel("Time [t]");ylabel("Frequency [Hz]")
title("Leaky DFT-CLMS time spectrum estimation")
