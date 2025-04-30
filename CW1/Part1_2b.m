clc
clear
close all;
addpath("function\")
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

%%
addpath("EEG_Data\");
load("EEG_Data_Assignment1.mat")

N = length(POz);                % Sample number
T = 1/fs;                       % Time period (1/sampling frequency)
fftn = 5*fs;                    % size of fft coefficient, 5*sampling frequency
t = (0:N-1)*T;                  % time step
f_fft = fs*(0:(fftn/2))/fftn;   % fft index
time_length = [10,5,1];         % window time length
window_length = time_length./T; % window size divide by time period

% Standard PSD without averaging 
PSD = cw_periodogram(POz,fftn,'');

% PSD with window averaging
PSD_10 = cw_average_periodogram(POz,fftn,window_length(1));
PSD_5  = cw_average_periodogram(POz,fftn,window_length(2));
PSD_1  = cw_average_periodogram(POz,fftn,window_length(3));

%% f4 and f5
figure()
plot(f_fft,PSD,"LineWidth",1);
hold on;
plot(f_fft,PSD_10,"LineWidth",1);
xlim([11 20]);
legend("Standard","Window Length = 10")
grid on;
xlabel("Frequency [Hz]");ylabel("Power/Frequency [W/Hz]");
title("PSD of EEG signal from Assignment 1")

figure()
plot(f_fft,PSD_1,"LineWidth",1);
hold on;
plot(f_fft,PSD_5,"LineWidth",1);
hold on;
plot(f_fft,PSD_10,"LineWidth",1);
xlim([11 20]);
legend("Window Length = 1","Window Length = 5","Window Length = 10");
grid on;
xlabel("Frequency [Hz]");ylabel("Power/Frequency [W/Hz]")
title("PSD of EEG signal from Assignment 1")
