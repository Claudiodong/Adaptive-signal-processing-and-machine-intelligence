clc
clear
close all;
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

load("EEG_Data\EEG_Data_Assignment1.mat")
a = 2000;
y = POz(a:a+1200-1);
L = length(y);
fs = 1200;

plot(y)


% DFT-CLMS
w = zeros(L,L);
mu = 1;
for i = 1:length(y)
    x_n = 1/L * exp(1i*(2*(i-1)*pi)/L * (0:L-1));
    y_est = w(:,i)'*x_n.';
    e = y(i) - y_est;
    w(:,i+1) = w(:,i) + mu*conj(e)*x_n.';
end
w = w(:,2:end);
w_true = [w(L/2+1:end,:);w(1:L/2,:)];

[xx,yy] = meshgrid(1:L, (-L/2+1:L/2)*(fs/L));
mesh(xx,yy,abs(w_true))
view(2);
colormap turbo;colorbar;
xlabel("Time [t]");ylabel("Frequency [Hz]");
title("EEG POz data Time-Frequency Estimation (DFT-CLMS)")
ylim([-10 100])
