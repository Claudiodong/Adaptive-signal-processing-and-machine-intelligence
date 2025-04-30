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
% Part 1.2

load sunspot.dat
year = sunspot(:,1);
sample = sunspot(:,2);
N = length(sample);
fs = 5*N;
T = 1/fs;
t = (0:N-1)*T;
fftn = 2048;
f_fft = fs*(0:(fftn/2))/fftn;

PSD_dB = cw_periodogram(sample,fftn,'dB');

% remove mean
sample_remove_mean = sample - mean(sample);
PSD_dB_mean_remove = cw_periodogram(sample_remove_mean,fftn,'dB');
% remove trend
sample_remove_trend = detrend(sample);
PSD_dB_trend = cw_periodogram(sample_remove_trend,fftn,'dB');


%%
figure()  % Comparsion of original and remove mean
subplot(2,1,1)
plot(0:N-1,sample,'b','LineWidth',1);
hold on;
plot(0:N-1,sample_remove_mean,"-.",'color',orange,'LineWidth',1);
grid on;
xlabel("Sample [n]");ylabel("Number of Sunspots");
legend("Original","Remove Mean");
title("Sunspots Data")

subplot(2,1,2)
plot(f_fft,PSD_dB,'b','LineWidth',1);
hold on;
plot(f_fft,PSD_dB_mean_remove,"-.k",'color',orange,'LineWidth',1);
grid on;
xlabel("Frequency [Hz]");ylabel("Power/Frequency [dB/Hz");
legend("Original","Remove Mean");
title("PSD")

%%
figure()  % Comparsion of original and remove trend
subplot(2,1,1)
plot(0:N-1,sample,'b','LineWidth',1);
hold on;
plot(0:N-1,sample_remove_trend,"-.",'color',orange,'LineWidth',1);
grid on;xlabel("Sample Number [n]");ylabel("Number of Sunspots");
legend("Original","Remove Trend");
title("Sunspots Data")

subplot(2,1,2)
plot(f_fft,PSD_dB,'b','LineWidth',1);
hold on;
plot(f_fft,PSD_dB_trend,"-.",'LineWidth',1);ylim([-20 60]);
grid on;
xlabel("Frequency [Hz]");ylabel("Power/Frequency [dB/Hz");
legend("Original","Remove Trend");
title("PSD")

%% log plot
log_sample = 10*log10(sample+1); % need to +1 if there is 0 observation on the sunspot
log_sample_remove_mean = log_sample - sum(log_sample)/N;

figure()  % Comparsion of original and remove mean
subplot(2,1,1)
plot(0:N-1,sample,'b','LineWidth',1);
grid on;xlabel("Sample Number [n]");ylabel("Number of Sunspots");
title("Sunspots Data")
subplot(2,1,2)
plot(0:N-1,log_sample_remove_mean,'color',orange,'LineWidth',1);
grid on;
xlabel("Sample Number [n]");ylabel("Number of Sunspots (dB)");
title("Sunspots Data (logarithm)")


