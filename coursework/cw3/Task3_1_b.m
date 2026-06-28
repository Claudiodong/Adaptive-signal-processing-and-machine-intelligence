clc
clear
close all;
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

%%
load("wind-dataset\high-wind.mat")
V_high = v_east + 1i*v_north;

load("wind-dataset\medium-wind.mat")
V_medium = v_east + 1i*v_north;

load("wind-dataset\low-wind.mat")
V_low = v_east + 1i*v_north;

clear  v_north v_east;

%% Scatter plot
figure()
scatter(real(V_high),imag(V_high),'.');
xlabel("Real");ylabel("imaginary ");
title("High Wind");grid on;

figure()
scatter(real(V_medium),imag(V_medium),'.')
xlabel("Real");ylabel("imaginary ")
title("Medium Wind");grid on;

figure()
scatter(real(V_low),imag(V_low),'.')
xlabel("Real");ylabel("imaginary ")
title("Slow Wind");grid on;

%% Circularity coefficient
c_high = V_high'*V_high/length(V_high);
p_high = V_high.'*V_high/length(V_high);
n_high = abs(p_high) / c_high;

c_medium = V_medium'*V_medium/length(V_medium);
p_medium = V_medium.'*V_medium/length(V_medium);
n_medium = abs(p_medium) / c_medium;

c_low = V_low'*V_low/length(V_low);
p_low = V_low.'*V_low/length(V_low);
n_low = abs(p_low) / c_low;

%% Apply CLMS, ACLMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M_max = 20;
mu =0.00001;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[A_clms_high,A_aclms_high,high_e_clms,high_e_aclms] = Wind_CLMS_ACLMS(M_max,V_high,mu);
[A_clms_medium,A_aclms_medium,medium_e_clms,medium_e_aclms] = Wind_CLMS_ACLMS(M_max,V_medium,mu);
[A_clms_slow,A_aclms_slow,slow_e_clms,slow_e_aclms] = Wind_CLMS_ACLMS(M_max,V_low,mu);

%%
figure()
plot(1:M_max, A_clms_high,'--r','LineWidth',2)
hold on;
plot(1:M_max, A_aclms_high,'--k','LineWidth',2)
hold on;
plot(1:M_max, A_clms_medium,'-.r','LineWidth',2)
hold on;
plot(1:M_max, A_aclms_medium,'-.k','LineWidth',2)
hold on;
plot(1:M_max, A_clms_slow,'-r','LineWidth',2)
hold on;
plot(1:M_max, A_aclms_slow,'-k','LineWidth',2)
grid on;
xlabel("Filter Order $M$");
ylabel("Prediction Gain $R_{p}$ [dB]");
legend("High CLMS","High ACLMS","Medium CLMS","Medium ACLMS","Low CLMS","Low ACLMS")
title("$\mu$=0.00001")
xlim([1, M_max])

%%
figure()
plot(1:M_max,10*log10(high_e_clms),'--r','LineWidth',2)
hold on;
plot(1:M_max,10*log10(high_e_aclms),'--k','LineWidth',2)
hold on;
plot(1:M_max,10*log10(medium_e_clms),'-.r','LineWidth',2)
hold on;
plot(1:M_max,10*log10(medium_e_aclms),'-.k','LineWidth',2)
hold on;
plot(1:M_max,10*log10(slow_e_clms),'-r','LineWidth',2)
hold on;
plot(1:M_max,10*log10(slow_e_aclms),'-k','LineWidth',2)
xlabel("Filter Order $M$");
ylabel("MSE [dB]");
legend("High CLMS","High ACLMS","Medium CLMS","Medium ACLMS","Low CLMS","Low ACLMS")
title("Learning Curve $\mu$=0.00001");grid on;

%%
function [A_clms,A_aclms,mean_e_clms,mean_e_aclms] = Wind_CLMS_ACLMS(M_max,V,mu)

    A_clms = zeros(1,M_max);
    A_aclms = zeros(1,M_max);
    mean_e_clms= zeros(1,M_max);
    mean_e_aclms= zeros(1,M_max);
    for i_M = 1:M_max
        [e_clms_H,~]=CLMS(i_M,V,V,mu);
        [e_aclms_H,~,~]=ACLMS(i_M,V,V,mu);

        mean_e_clms(i_M) = mean(abs(e_clms_H).^2);
        mean_e_aclms(i_M) = mean(abs(e_aclms_H).^2);

        B_clms = mean(abs(V(i_M:end)).^2);
        B_aclms = mean(abs(V(i_M:end)).^2);

        % Prediction Gain in (dB)
        A_clms(i_M) = 10*log10( B_clms/mean_e_clms(i_M));
        A_aclms(i_M) = 10*log10(B_aclms/mean_e_aclms(i_M));
    end
end