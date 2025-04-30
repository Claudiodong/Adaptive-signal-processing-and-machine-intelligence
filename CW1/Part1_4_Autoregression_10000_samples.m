clc
clear
close all;
addpath("function\");
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%% signal coefficient
coefficient = [2.76,-3.81,2.65,-0.92];% coefficient AR
flip_coe = flip(coefficient);         % flip the coefficient
Num_sample = 10000;                    % number of sample
N_c = length(coefficient);            % number of coefficient
sigma = 1;                            % noise variance
fftn = 2048;                          % number of sample freqeuncy
index = 1:fftn/2;                   % plot index
x = zeros(Num_sample+N_c,1);          % predefine the variables
plot_index = (0:2*pi/(fftn-1):pi)/pi;          % pi radians


for i = N_c+1:Num_sample+N_c
    % generate the AR signal
    x(i) = flip_coe*x(i-4:i-1) + sqrt(sigma)*randn(1,1);
end
% filter out the fisrt 500 signal
x_filter = x(N_c+1+Num_sample/2 : end);


%% Gnenerate the AR power
PSD = AR_PSD(coefficient,fftn,sigma);
PSD_dB = 10*log10(PSD);

%% estimation using ACF and Yule-Walker Method (MEM) Maximum Entropy Method
[ACF_biased,k_biased] = biased_ACF(x_filter);

%% using the order from 2:14
p_order = 2:14;
PSD_estimate = zeros(length(p_order),fftn);
error = zeros(1,length(p_order));
for i = 1:length(p_order)
    [ACF_p_coeff,sigma_estimate] = Yule_Walker_estimation(p_order(i),ACF_biased);
    % PSD estimation
    PSD_estimate(i,:) = AR_PSD(ACF_p_coeff,fftn,sigma_estimate);

    % Compute the MSE
    error(i) = mean((PSD - PSD_estimate(i,:)).^2);
end
% try to identify the best p number for the PSD estimation.
[~,best_p] = min(error);
PSD_estimate_dB = 10*log10(PSD_estimate(best_p,:)); 
%% plotting the graph
figure()
subplot(2,1,1)
semilogy(p_order,error,'-X','LineWidth',1.5,'MarkerSize',8);
grid on;xlabel("p model order");ylabel("Mean Sqaure Error");
title("Mean Square Error of each p model order");

subplot(2,1,2)
plot(plot_index,PSD_dB(index));
grid on;hold on;
plot(plot_index,PSD_estimate_dB(index));
xlabel("Frequency [$\pi$ radians]");ylabel("Power/Frequency [dB/$\pi$]");
legend("Actual PSD",sprintf("PSD estimation (p=%1.0f)",p_order(best_p)));
title("Comparsion of Actual PSD and Estimate PSD with 10000 Samples");
