clc
clear
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
addpath("function_task2\")
%%
% Task 2_3 ALE ANC
L = 1000;
Max = 1000;        % Monte carlo
mu = 0.001;        % step size
N_coeff = [5,10];

[x_5,avg_e_5,ANC5_MSPE]=ANC(Max,L,mu,N_coeff(1));

[x_10,avg_e_10,ANC10_MSPE]=ANC(Max,L,mu,N_coeff(2));

[x_53,x_hat_avg_53,ALE5_MSPE] = ALE(N_coeff(1),L,mu,6,Max); 

[x_103,x_hat_avg_103,ALE10_MSPE] = ALE(N_coeff(2),L,mu,6,Max);

fprintf("ANC order = %2.0f, MSPE = %1.5f dB\n",N_coeff(1),10*log10(ANC5_MSPE))
fprintf("ANC order = %2.0f, MSPE = %1.5f dB\n",N_coeff(2),10*log10(ANC10_MSPE))

fprintf("ALE order = %2.0f and delay 6, MSPE = %1.5f dB\n",N_coeff(1),10*log10(ALE5_MSPE))
fprintf("ALE order = %2.0f and delay 6, MSPE = %1.5f dB\n",N_coeff(2),10*log10(ALE10_MSPE))

%%
figure()
plot(avg_e_5,"LineWidth",2)
hold on;
plot(x_5,"LineWidth",1.5);
hold on;
plot(x_hat_avg_53,"LineWidth",1.5);
xlabel("Sample Number",'fontsize',12);
ylabel("Magnitude",'fontsize',12)
title("Order = 5,$\Delta=6$",'fontsize',12);
legend("ANC","Pure signal x",'ALE');
grid on

figure
plot(avg_e_10,"LineWidth",2)
hold on;
plot(x_10,"LineWidth",1.5);
hold on;
plot(x_hat_avg_103,"LineWidth",1.5);
xlabel("Sample Number",'fontsize',12);
ylabel("Magnitude",'fontsize',12)
title("Order = 10,$\Delta=6$",'fontsize',12);
legend("ANC","Pure signal x",'ALE');
grid on;

corr_coeff = 0:0.1:1;
for i = 1:length(corr_coeff)
[~,~,MPSE_corr5(i)]=ANC_vary_noise(Max,L,mu,N_coeff(1),corr_coeff(i));
[~,~,MPSE_corr10(i)]=ANC_vary_noise(Max,L,mu,N_coeff(2),corr_coeff(i));
end
%%
figure()
plot(10*log10(MPSE_corr5),'-.x','LineWidth',2);
hold on;
plot(10*log10(MPSE_corr10),'-O','LineWidth',2);
ylabel("MSPE [dB]");
xlabel("correlation coefficient")



%% ANC adaptive noise cancellation, which adapte the noise, and error is the estimate pure signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Inpur
% - Max (1x1 double) = The number of monte carlo
% - L (1X1 double) = The number of sample
% - mu (1*N) = The step size
% - N_coeff (1*N) = The order of the filter 
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Output:
% - x (L*1) = pure signal (desired signal wanted)
% - avg_e (L*1) = average error signal (which is the pure signal is ANC)
% sicne e = d - estimate noise
% - MPSE (1*1) = mean squared prediction error
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function  [x,avg_e,MPSE]=ANC_vary_noise(Max,L,mu,N_coeff,correlation_gain)
         e = zeros(L,Max);
        % ANC process
        MSPE_all = 0;
        for max = 1:Max
                n = randn(1,L);
                color_noise = zeros(L+2,1);
                % MA color noise
                 for i = 3:L
                     color_noise(i) = n(i) + 0.5*n(i-2);
                 end
                 color_noise = color_noise(3:end);
        
                 % pure signal
                 x = sin(0.01*pi*(1:L)).';
                    
                 % signal
                s = x + color_noise;
                
                % secondary noise should have size L*1
                sec_noise = correlation_gain*color_noise + 0.8*randn(L,1);
        
                w = zeros(N_coeff,1); % define the weight should be M*1 size
        
                for j = 1+N_coeff:length(sec_noise)
                    u = flip(sec_noise(j-N_coeff+1:j)); % the u
                    noise_hat = w'*u;                % estimate noise
                    x_hat = s(j) - noise_hat;        % the error 
                    e(j,max) = x_hat;
                    % update the weight
                    w = w + mu* x_hat * u;
                end
                x = x(N_coeff+1:end);
                MSPE_all = sum((x-e(N_coeff+1:end,max)).^2)/ length(x) + MSPE_all;
        end
        
        % average error
        avg_e = mean(e,2);
        avg_e = avg_e(N_coeff+1:end);
        
        
        MPSE = MSPE_all/Max;
end




