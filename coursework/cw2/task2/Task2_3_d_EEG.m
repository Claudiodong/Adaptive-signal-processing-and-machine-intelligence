clc
clear
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
addpath("function_task2\")

load("EEG_Data\EEG_Data_Assignment2.mat");
T = 1/fs;
L = length(Cz);
window = 1500;
overlap = 200;
fft_length = 2048;
N_coeff = 15;

figure % original without ANC
spectrogram(Cz,window,overlap,fft_length,fs)
title("Spectrum of EEG (Cz) data")
ylabel(colorbar,"Power/Frequency [dB/Hz]",'interpreter','latex');

% To remove the 50 Hz noise freuqency componenet
% reference signal (sin) with AWGN 
reference = sin(2*pi*50*(1:L)*T) + randn(1,L);

% ANC
e = zeros(L,1);
mu = 0.01;
w = zeros(N_coeff,1);
for i = 1+N_coeff : length(Cz)
    u = flip(reference(i-N_coeff+1 : i)).';
    noise_hat = w'*u;
    e(i) = Cz(i) - noise_hat;
    w = w + mu*e(i)*u;
end

figure % original without ANC
spectrogram(e,window,overlap,fft_length,fs);
title("Spectrum of EEG (Cz) data after ANC")
ylabel(colorbar,"Power/Frequency [dB/Hz]",'interpreter','latex');