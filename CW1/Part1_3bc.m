clc
clear
close all;
addpath("function\")
orange = [0.8500 0.3250 0.0980];
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

%%
fftn = 2048;                  % FFT coefficient
fs = 200;                     % sampling freqeuncy
T = 1/fs;                     % time period
L = 30;                       % length of the signal
t = (0:L-1)*T;                % period
N = 100;                      % number of realisaion                          
f_fft = fs*(0:(fftn/2))/fftn; % fft index
p = 1:fftn/2;
w = (0:2*pi/(fftn-1):pi)/pi;

% predefine the variables
PSD_sum = zeros(1,fftn);
PSD_all = zeros(N,fftn);
subplot(2,1,1)
for i = 1:N
    % Generate the  complex Noise
    noise = randn(size(t));
    %noise = 0.3*randn(1,length(t));
    % Gnenerate the signal
    x = 0.8*exp(1i*2*pi*20*t)+1.5*exp(1i*2*pi*60*t)+noise;
    [ACF_biased,k_biased]=biased_ACF(x);            % ccompute the ACF
    PSD = correlogram(ACF_biased,fftn,k_biased,''); % PSD not in dB
    PSD_sum = PSD+PSD_sum;                          % summing the PSD
    plot(w,PSD(p),'-c');                            % plot the PSD
    hold on;
    PSD_all(i,:) = PSD;                             % store all the PSD   
end
%% 
% plot the average of 100 realisation
PSD_mean = PSD_sum / N;
plot(w,PSD_mean(p),'Color',orange,"LineWidth",2);
grid on;xlabel("Frequency [$\pi$ radians]");ylabel("Power/Frequency [W/Hz]");
%title("PSD estimation of 100 realisations and Mean");

%  variance
sd = sqrt(1/N * sum((PSD_all - PSD_mean).^2,1));
subplot(2,1,2)
plot(w,sd(p),"LineWidth",2);grid on;
xlabel("Frequency [$\pi$ radians]");ylabel("Magnitude");
%title("PSD Standard Deviation")

%% plot in dB
PSD_all_dB = 10*log10(PSD_all);
figure()
subplot(2,1,1)
PSD_dB_sum = 0;
for i = 1:N
    PSD_dB = PSD_all_dB(i,:);
    plot(w,PSD_dB(p),'-c');hold on;
    PSD_dB_sum = PSD_dB+PSD_dB_sum;
end

PSD_dB_avg = PSD_dB_sum ./N;
plot(w,PSD_dB_avg(p),'Color',orange,"LineWidth",2);
grid on;xlabel("Frequency [$\pi$ radians]");ylabel("Power/Frequency [dB/$\pi$]");
%title("PSD estimation of 100 realisations and Mean");

subplot(2,1,2)
%  variance
sd_dB = sqrt(1/N * sum((PSD_all_dB - PSD_dB_avg).^2,1));
subplot(2,1,2)
plot(w,sd_dB(p),'Color',orange,"LineWidth",2);grid on;
xlabel("Frequency [$\pi$ radians]");ylabel("Magnitude [dB]");
%title("PSD Standard Deviation")