clc
clear
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%% Part 1.1
addpath("function\");
%% generate a pulse
N = 200;

Impulse = zeros(1,N);
Impulse(1) = 10;
time_index = (0:N-1)/100;

%% Autocovariance function (ACF)
correlation = xcorr(Impulse,'unbiased');
ACF_index = -N+1:N-1;

%% PSD
magnitude = fft(Impulse);
Power = abs(magnitude).^2;
f_psd = (0:N-1)/N;

%% plot
figure()
subplot(3,1,1)
plot(time_index,Impulse);
grid on;xlabel("Time [t]");ylabel("Magnitude");ylim([-2 11]);xlim([-0.1 2])
title("Impulse Sequence");

subplot(3,1,2)
plot(ACF_index,correlation)
grid on;ylim([-0.1 0.6]);xlabel("k");ylabel("Magnitude");
title("ACF");

subplot(3,1,3)
plot(f_psd,10*log10(Power));
grid on;xlabel("Frequency [Hz]");ylabel("Power/Freqeuncy [dB/Hz]");
title("PSD")



