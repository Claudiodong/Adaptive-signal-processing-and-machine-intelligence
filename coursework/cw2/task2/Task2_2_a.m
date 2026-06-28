clc
clear
close all;
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
addpath("function_task2\")

% MA(1),generate the signal
N = 2000;                           % The number of sample
N_coeff = 1;                        % The number of coefficient
coefficient = 0.9;
x = zeros(1,N_coeff+N);
mu_initilise = [0.1,0.01];          % initilise the step size
rho = 0.0003;                       % the change in step size
Max = 300;                          % The number of realisation

weigth_error_B = zeros(Max,length(x)+1);
weigth_error_A = zeros(Max,length(x)+1);
weigth_error_M = zeros(Max,length(x)+1);
weigth_error_normal_001 = zeros(Max,length(x)+1);
weigth_error_normal_01 = zeros(Max,length(x)+1);

for j = 1:Max
    % Generate the MA(1) signal
    n = 1/sqrt(2) * randn(1,N+N_coeff);
    for i = 1+N_coeff:N+N_coeff
        x(i) = coefficient*n(i-1) + n(i);
    end
    
    % LMS function with adaptive step size (Gass) / use 0.1 by change from
    % 2 to 1.
    [w_B,~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(2),'B',rho);
    [w_A,~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(2),'A',rho);
    [w_M,~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(2),'M',rho);

    % LMS without adaptive step size
    [w_normal_001,~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(2),'',rho);
    [w_normal_01,~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(1),'',rho);

    % weight error
    weigth_error_B(j,:) = coefficient - w_B;
    weigth_error_A(j,:) = coefficient - w_A;
    weigth_error_M(j,:) = coefficient - w_M;

    weigth_error_normal_001(j,:) = coefficient - w_normal_001;
    weigth_error_normal_01(j,:) = coefficient - w_normal_01;
end
% Average weight error
Avg_weight_error_B = mean(weigth_error_B,1);
Avg_weight_error_A = mean(weigth_error_A,1);
Avg_weight_error_M = mean(weigth_error_M,1);
Avg_weight_error_normal_001 = mean(weigth_error_normal_001,1);
Avg_weight_error_normal_01 = mean(weigth_error_normal_01,1);



%%
% figure for \mu=0.01
figure()
plot(1:N+2,Avg_weight_error_normal_001,'LineWidth',1)
hold on;
plot(1:N+2,Avg_weight_error_normal_01,'LineWidth',1)
hold on;
plot(1:N+2,Avg_weight_error_B,'LineWidth',1)
hold on;
plot(1:N+2,Avg_weight_error_A,'LineWidth',1)
hold on;
plot(1:N+2,Avg_weight_error_M,'LineWidth',1)
hold on;
legend('Standard LMS $\mu$=0.01','Standard LMS $\mu$=0.1',"Benveniste $\mu$(0)=0.01","Ang $\&$ Farhang $\mu$(0)=0.01","Matthews $\mu$(0)=0.01",'fontsize',12);
xlabel("Sample Number",'fontsize',15);ylabel("Weight error",'fontsize',15);grid on;
xlim([1,N+2]);

% figure for \mu=0.1
% figure()
% plot(1:N+2,Avg_weight_error_normal_001,'LineWidth',1)
% hold on;
% plot(1:N+2,Avg_weight_error_normal_01,'LineWidth',1)
% hold on;
% plot(1:N+2,Avg_weight_error_B,'LineWidth',1)
% hold on;
% plot(1:N+2,Avg_weight_error_A,'LineWidth',1)
% hold on;
% plot(1:N+2,Avg_weight_error_M,'LineWidth',1)
% legend('Standard LMS $\mu$=0.01','Standard LMS $\mu$=0.1',"Benveniste $\mu$(0)=0.1","Ang $\&$ Farhang $\mu$(0)=0.1","Mattew $\mu$(0)=0.1");
% xlabel("Sample Number");ylabel("Weight error");grid on;
% xlim([1,N+2]);

