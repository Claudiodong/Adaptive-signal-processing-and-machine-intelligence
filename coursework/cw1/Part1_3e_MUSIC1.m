clc
clear
close all;

addpath("function\");
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%% MUSIC Detection
L = 30;                       % length of signal
fftn = 2048;                  % FFT coefficient
fs = 1;                       % sampling freqeuncy should be lower since freqeuncy is 0.3 and 0.32 Hz
T = 1/fs;                     % time period
N = 10;                      % number of realisaion                          
f_fft = fs*(0:(fftn/2))/fftn; % fft index
p = 1:fftn/2+1;               % x-index
t = (0:L-1)*T;

% Generate the complex Noise
noise = 0.2/sqrt(2) *(randn(size(t))+1i*randn(size(t)));
% Gnenerate the exponential sin signal
x = exp(1j*2*pi*0.32*t)+exp(1i*2*pi*0.3*t)+noise;

figure()
[X,R] = corrmtx(x,14,'mod');
[S,F] = pmusic(R,2,[],1,'corr');
plot(F,S,'LineWidth',2);set(gca,'xlim',[0.25 0.40]);
grid on;xlabel("Frequency [Hz]");ylabel("Pseudospectrum")