clc
clear
close all;
orange = [0.8500 0.3250 0.0980];
addpath("function\");
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%% generate a WGN signal 
fs = 500;                              % sampling freqeuncy
T = 1/fs;                              % time period
N = 200;                               % Number of sample
t = (0:N-1)*T;                         % time step
fftn = 2048;                           % FFT coefficients
f_fft = fs*(0:(fftn/2))/fftn;          % fft index

%% ACF
y = randn(1,N); % generate random noise (WGN)
[ACF_biased,k_biased]= biased_ACF(y);
[ACF_unbiased,k_unbiased] = unbiased_ACF(y);

%% PSD by correlogram spectrum estimator
PSD_dB_biased = correlogram(ACF_biased,fftn,k_biased,'');
PSD_dB_unbiased = correlogram(ACF_unbiased,fftn,k_unbiased,'');

%% ACF
figure()
subplot(2,1,1);
plot(k_biased,ACF_biased,'b',"LineWidth",1);
hold on;grid on;
plot(k_unbiased,ACF_unbiased,'Color',orange,"LineWidth",1);
legend("Biased","Unbiased"); xlabel("Lags k");
ylabel("Magnitude");title("Comparsion of ACF");

%% correlogram
subplot(2,1,2);
plot(f_fft,PSD_dB_biased(1:fftn/2+1),'b',"LineWidth",1);
hold on;title("Correlogram");ylim([-150 200]);
plot(f_fft,PSD_dB_unbiased(1:fftn/2+1),'Color',orange,"LineWidth",1);
legend("Biased","Unbiased");grid on;xlabel("Frequency [Hz]");
ylabel("Power/Frequency [W/Hz]");

