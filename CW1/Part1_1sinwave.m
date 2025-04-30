clear;
clc;
close;
addpath("function\");
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%%
f= 50;            % Frequency [Hz]
fs = 500;         % Sampling frequency [Hz]
T = 1/fs;         % Time period
L = 200;          % Length of the signal
t=(0:L-1)*T;      % Time Period
y=sin(2*pi*f*t);  % generated signal (sin wave)
fftn = 2048;      % number of fft sampling
f_fft = fs*(0:(fftn/2))/fftn;

% Gnenerate the ACF autocorrelation function
ACF = biased_ACF(y);

% figure 1
figure()          % sequence plot
subplot(3,1,1)
plot(t,y)
xlabel('Time [s]');ylabel('Magnitude');ylim([-2 2]);title("Sine Wave Sequence")
grid on;

subplot(3,1,2)    % ACF plot
plot(-L+1:L-1,ACF);grid on;title("ACF");xlabel("Lags k");ylabel("Magnitude")

subplot(3,1,3)    % PSD plot
PSD_dB = cw_periodogram(y,fftn,'dB');
plot(f_fft,PSD_dB);grid on;ylim([-100 50]);
xlabel("Frequency [Hz]");ylabel("Power/Frequency [dB/Hz]");
title("PSD",'interpreter','latex')

