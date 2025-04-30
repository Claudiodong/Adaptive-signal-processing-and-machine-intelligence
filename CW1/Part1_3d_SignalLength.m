clc
clear
close all;
addpath("function\")
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%%
fftn = 2048;                  % FFT coefficient
fs = 2;                       % sampling freqeuncy should be lower since freqeuncy is 0.3 and 0.32 Hz
T = 1/fs;                     % time period
L = 10:30:100;                 % length of the signal
N = 100;                      % number of realisaion                          
f_fft = fs*(0:(fftn/2))/fftn; % fft index
p = 1:fftn/2+1;

for i_time = 1:length(L)
    t = (0:L(i_time)-1).*T;   % period
    % Generate the complex Noise
    noise = 0.2/sqrt(2) *(randn(size(t))+1i*randn(size(t)));
    %noise = 0.3*randn(1,length(t));

    % Gnenerate the exponential sin signal
    x = 0.8*exp(1j*2*pi*0.32*t)+exp(1i*2*pi*0.3*t)+noise;

    % calculate the PSD in dB
    PSD_dB = cw_periodogram(x,fftn,'dB');

    % plotting PSD dB 
    subplot(2,2,i_time)
    plot(f_fft,PSD_dB(p),'Color',[0.8500 0.3250 0.0980],"LineWidth",1); % orange color
    xlabel("Frequency [Hz]");ylabel("Power/Frequency [dB/Hz]");
    title(sprintf("PSD Periodogram Estimation with signal length (N=%1.0f) ",L(i_time)));
    grid on;
    % from obeservation, longer number of signal length is able to
    % disthinguish the close signals which has frequency of 0.3 and 0.32 Hz in this case. 
end
   

