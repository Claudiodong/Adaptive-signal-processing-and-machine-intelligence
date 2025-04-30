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
N_coeff = 5:5:20; % filter order
delta = 0:25;     % delay range
Max = 100;        % Monte carlo
mu = 0.001;        % step size

%%
MSPE = zeros(length(N_coeff),length(delta));
% ALE process
for i = 1:length(N_coeff)
    for j = 1:length(delta)
        [~,x_hat_avg,MSPE(i,j)] = ALE(N_coeff(i),L,mu,delta(j),Max); 
    end
end

%%

figure()
for i = 1:length(N_coeff)
plot(delta,10*log10(MSPE(i,:)),"LineWidth",1.5);
hold on
end
xlabel("Delay $\Delta$",'fontsize',15);ylabel("MSPE [dB]",'fontsize',15)
legend("Order M=5","Order M=10","Order M=15","Order M=20",'fontsize',12)
title(['$\mu = $',num2str(mu)]);
grid on;


%% 
[x_0,x_hat_avg_0,MSPE_0] = ALE(5,L,mu,0,Max); 
[x_3,x_hat_avg_3,MSPE_3] = ALE(5,L,mu,3,Max); 

% plot(x_hat_avg_0,'LineWidth',2)
% hold on;
% plot(x,'LineWidth',1)
% legend("Estimated pure signal $\hat{x}$","Pure signal x",'fontsize',12)
% xlabel("Sample Number",'fontsize',15)
% ylabel("Magnitude",'fontsize',15);
% grid on;title("$\Delta$ = 0, Order=5")
% ylim([-1.5,1.5])
% 
% 
% figure()
% plot(x_hat_avg_3,'LineWidth',2)
% hold on;
% plot(x,'LineWidth',1)
% legend("Estimated pure signal $\hat{x}$","Pure signal x",'fontsize',12)
% xlabel("Sample Number",'fontsize',15)
% ylabel("Magnitude",'fontsize',15);
% grid on;ylim([-1.5,1.5])
% title("$\Delta$ = 4, Order=5")


%%
n = randn(1,L);
color_noise = zeros(L+2,1);
% MA color noise
 for i = 3:L
     color_noise(i) = n(i) + 0.5*n(i-2);
 end
 color_noise = color_noise(3:end);

 % pure signal
 x = sin( 0.01*pi*(1:L)).';
    
 % signal
s = x + color_noise;


%%
figure()

subplot(3,1,1)
plot(s);
grid on;
xlabel("Sample Number",'fontsize',12);
ylabel("Magnitude",'fontsize',12);
title(" Noise-corrupted signal $s(n)$")


subplot(3,1,2)
plot(x_hat_avg_0,'LineWidth',2)
hold on;
plot(x_0,'LineWidth',1)
legend("Estimated pure signal $\hat{x}$","Pure signal x")
xlabel("Sample Number [n]",'fontsize',12)
ylabel("Magnitude",'fontsize',12);
grid on;
title(['$\Delta$ = 0, Order=5',',$\mu$=',num2str(mu)]);
ylim([-1.5,1.5]);


subplot(3,1,3)
plot(x_hat_avg_3,'LineWidth',2)
hold on;
plot(x_3,'LineWidth',1)
legend("Estimated pure signal $\hat{x}$","Pure signal x")
xlabel("Sample Number [n]",'fontsize',12)
ylabel("Magnitude",'fontsize',12);
grid on;ylim([-1.5,1.5]);
title(['$\Delta$ = 3, Order=5',',$\mu$=',num2str(mu)]);

figure()
plot(N_coeff,MSPE(:,4))

