clc
clear
close all;
%%
addpath("function\");
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%% read the CSV file
% Recordings = readtable("Second_Recording_2024-01-23-165538_EEG.csv");
% Timestamp = table2array(Recordings(:,1));
% CH1 = table2array(Recordings(:,2));

%[xRRI,fsRRI] = ECG_to_RRI(CH1,fs);

%%
%save("RRI_data.mat","xRRI","fsRRI");
%%
load("RRI_data.mat")
fs = fsRRI;                     % sampling frequency is 500 Hz;
fftn = 2048;                    % number of fft coefficient
f_fft = fs*(0:(fftn/2))/fftn; % fft index

% plot of all data
figure()
plot(xRRI)
% split into 3 parts
trial1 = xRRI(1:1399);
trial2 = xRRI(1400:2225);
trial3 = xRRI(2226:3300);
% plot for the 3 trials
figure()
subplot(3,1,1)
plot(0:length(trial1)-1,trial1);title("Trail1")
subplot(3,1,2)
plot(0:length(trial2)-1,trial2);title("Trail2")
subplot(3,1,3)
plot(0:length(trial3)-1,trial3);title("Trail3")

%% analysis start

%% Standard peridogram
PSD1_dB = cw_periodogram(trial1,fftn,'dB');
PSD2_dB = cw_periodogram(trial2,fftn,'dB');
PSD3_dB = cw_periodogram(trial3,fftn,'dB');

figure()  % figure of standard 
subplot(3,1,1)
plot(f_fft,PSD1_dB,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title("PSD of Trial 1");grid on;
subplot(3,1,2)
plot(f_fft,PSD2_dB,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title("PSD of Trial 2");grid on;
subplot(3,1,3)
plot(f_fft,PSD3_dB,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title("PSD of Trial 3");grid on;

% apply window for the average periodogram
time_length = [50,150];
window_length = time_length*fsRRI;
% window length of 50s
Avg_PSD1_dB = cw_average_periodogram(trial1.',fftn,window_length(1));
Avg_PSD2_dB = cw_average_periodogram(trial2.',fftn,window_length(1));
Avg_PSD3_dB = cw_average_periodogram(trial3.',fftn,window_length(1));
Avg_PSD1_dB = 10*log10(Avg_PSD1_dB);
Avg_PSD2_dB = 10*log10(Avg_PSD2_dB);
Avg_PSD3_dB = 10*log10(Avg_PSD3_dB);

figure() % figure of avergae periodogram with 50 window time
subplot(3,1,1)
plot(f_fft,Avg_PSD1_dB,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title(sprintf("Average Periodogram PSD of Trial 1 (Window Length=%1.0f)",time_length(1)));grid on;
subplot(3,1,2)
plot(f_fft,Avg_PSD2_dB,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title(sprintf("Average Periodogram PSD of Trial 2 (Window Length=%1.0f)",time_length(1)));grid on;
subplot(3,1,3)
plot(f_fft,Avg_PSD3_dB,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title(sprintf("Average Periodogram PSD of Trial 3 (Window Length=%1.0f)",time_length(1)));grid on;

%% window length of 150s
Avg_PSD1_dB_150 = cw_average_periodogram(trial1.',fftn,window_length(2));
Avg_PSD2_dB_150 = cw_average_periodogram(trial2.',fftn,window_length(2));
Avg_PSD3_dB_150 = cw_average_periodogram(trial3.',fftn,window_length(2));
Avg_PSD1_dB_150 = 10*log10(Avg_PSD1_dB_150);
Avg_PSD2_dB_150 = 10*log10(Avg_PSD2_dB_150);
Avg_PSD3_dB_150 = 10*log10(Avg_PSD3_dB_150);

figure()  % figure of avergae periodogram with 150 window time
subplot(3,1,1)
plot(f_fft,Avg_PSD1_dB_150,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title(sprintf("Average Periodogram PSD of Trial 1 (Window Length=%1.0f)",time_length(2)));grid on;
subplot(3,1,2)
plot(f_fft,Avg_PSD2_dB_150,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title(sprintf("Average Periodogram PSD of Trial 2 (Window Length=%1.0f)",time_length(2)));grid on;
subplot(3,1,3)
plot(f_fft,Avg_PSD3_dB_150,'LineWidth',1);xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");
title(sprintf("Average Periodogram PSD of Trial 3 (Window Length=%1.0f)",time_length(2)));grid on;

%% AR spectrum by estimation with p model order
p = 60; % model order
ACF_coefficient1 = aryule(trial1,p);
ACF_coefficient2 = aryule(trial2,p);
ACF_coefficient3 = aryule(trial3,p);
% The first element in the coefficient is the sigma, noise power
% then rest of the coefficient need to add '-' on it
PSD_estimate1 = AR_PSD(-ACF_coefficient1(2:end),fftn,ACF_coefficient1(1));
PSD_estimate2 = AR_PSD(-ACF_coefficient2(2:end),fftn,ACF_coefficient2(1));
PSD_estimate3 = AR_PSD(-ACF_coefficient3(2:end),fftn,ACF_coefficient3(1));
PSD_dB_estimate1 = 10*log10(PSD_estimate1);
PSD_dB_estimate2 = 10*log10(PSD_estimate2);
PSD_dB_estimate3 = 10*log10(PSD_estimate3);

figure() % figrue of AR spectrum estimation
subplot(3,1,1)
plot(f_fft,PSD_dB_estimate1(1:fftn/2+1),'LineWidth',1);
xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");grid on;
title("AR Spectrum estimation of Trail 1")
subplot(3,1,2)
plot(f_fft,PSD_dB_estimate2(1:fftn/2+1),'LineWidth',1);
xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");grid on;
title("AR Spectrum estimation of Trail 2")
subplot(3,1,3)
plot(f_fft,PSD_dB_estimate3(1:fftn/2+1),'LineWidth',1); 
xlabel("Frequency [Hz]");ylabel("Magnitude [dB]");grid on;
title("AR Spectrum estimation of Trail 3")
