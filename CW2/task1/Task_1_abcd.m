clc
clear
close all;
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

%% parameters
coefficient = [0.1,0.8]; % The coefficient for the second order AR sequence
sigma = 0.25;            % The power for the noise
N_sample = 1500;         % The number of sample
N_c = length(coefficient); % The length of the coefficient

[x]=AR_generator(coefficient,N_sample,sigma);

%% Task a, find the correlation matrix and step size miu

% Find the correlation matrix
syms r0 r1 r2; % define the variable

% define the ACF (autocorrelation function)
R = [r0,r1,r2;
     r1,r0,r1;
     r2,r1,r0];

% forming thr equation
equation = R*[1;0.1;0.8] == [sigma;0;0];

% solve the equation and output the correlation value
[r0,r1,r2] = solve(equation);
% convert into double type in decimal
r_xx = double([r0,r1,r2]);

R1 = [r_xx(1),r_xx(2);r_xx(2),r_xx(1)];

% The step size range is 0<u<(2/max(lambda)), the largest eignvalue in the
% correlation matrix, which is the diagonal value, then it is r0 in this
% case.
u_max_practical = 2/trace(R1);
%u_max_theoretical = 2/max(eig(R1))

%% Task B implement the LMS algorithm
miu = [0.01,0.05];

% % Initlise the weight w
% w = zeros(N_c,1); % The number of weight should be the same as the coefficient
% w_all = [];
% % Adaption
% for n = 1+N_c:N_sample+N_c
% 
%     % previous two data
%     x_n = [x(n-1);x(n-2)];
% 
%     % Error = true - estimate
%     e(n) = x(n) - w' * x_n;
% 
%     % update the weight
%     w = w + miu*e(n)*x_n;
% 
%     % Store all the weight
%     w_all = [w_all,w];
% end

%% Single Realisation
%  LMS miu = 0.05 
[error_005_single,w_all_005_single] = LMS_AR2(x,miu(2),N_c);

%  LMS miu = 0.05 
[error_001_single,w_all_001_single] = LMS_AR2(x,miu(1),N_c);

%% 100 realisation
% E_all_001 = 0;
%E_all_005 = 0;
W_all_001 = 0;
W_all_005 = 0;
for i = 1:100
    % Generate the AR signal
    [x_trial]=AR_generator(coefficient,N_sample,sigma);

    % Perfrom LMS for 0.01
    [error_001,w_all_001] = LMS_AR2(x_trial,miu(1),N_c);

    % Perfrom LMS for 0.05
    [error_005,w_all_005] = LMS_AR2(x_trial,miu(2),N_c);

    % collect all the error and weight
    E_all_001(i,:) = error_001;
    E_all_005(i,:) = error_005;
    W_all_001 = W_all_001+w_all_001;
    W_all_005 = W_all_005+w_all_005;
end
Avg_E_001 =    mean(10.*log10(E_all_001.^2),1);
Avg_E_005_sq = mean(10.*log10(E_all_005.^2),1);
Avg_W_001 = W_all_001/100;
Avg_W_005 = W_all_005/100;


%% error squared and mean squared error
figure()
subplot(2,1,2)
plot(1:N_sample,Avg_E_001(3:end),'b-');
grid on;
title("100 Realisations $\mu$=0.01");
xlabel("Sample Number [n]");ylabel("MSE [dB]");

subplot(2,1,1)
plot(1:N_sample,10.*log10(error_001_single(3:end).^2),'b-');
grid on;
xlabel("Sample Number [n]");ylabel("$e^2$ [dB]");
title("Single Realisation $\mu$=0.01");

figure()
subplot(2,1,1)
plot(1:N_sample,10.*log10(error_005_single(3:end).^2),'b-');
grid on;
xlabel("Sample Number [n]");ylabel("$e^2$ [dB]");
title("Single Realisation $\mu$=0.05");

subplot(2,1,2)
plot(1:N_sample,(Avg_E_005_sq(3:end)),'b-');
grid on;
title("100 Realisations $\mu$=0.05 ");
xlabel("Sample Number [n]");ylabel("MSE [dB]");

%% weight evolution plot
figure()

plot(1:N_sample,Avg_W_001(1,:))
hold on;grid on;
plot(1:N_sample,Avg_W_001(2,:))
hold on;
plot(1:N_sample,coefficient(1)*ones(1,N_sample),'k--');
hold on;
plot(1:N_sample,coefficient(2)*ones(1,N_sample),'k--')
title("LMS with step size $\mu$=0.01 with 100 realisation");
legend("Estimate $a_1$","Estimate $a_2$","Actual $a_1$","Actual $a_2$",'FontSize',12);
xlabel("Sample Number [n]",'FontSize',12);ylabel("Weight evolution",'FontSize',12);
ylim([0 1])



figure
plot(1:N_sample,Avg_W_005(1,:))
hold on;grid on;
plot(1:N_sample,Avg_W_005(2,:));
hold on;
plot(1:N_sample,coefficient(1)*ones(1,N_sample),'k--');
hold on;
plot(1:N_sample,coefficient(2)*ones(1,N_sample),'k--')
title("LMS with step size $\mu$=0.05 with 100 realisation");
legend("Estimate $a_1$","Estimate $a_2$","Actual $a_1$","Actual $a_2$",'FontSize',12);
xlabel("Sample Number [n]",'FontSize',12);ylabel("Weight evolution",'FontSize',12);
ylim([0 1])

%% Task c
% MSE = noise_power + EMSE
% Misadjustment(estimated) = EMSE/noise_power

% In order to find the EMSE, we only need to take the statonary part of the
% MSE, which should be fairly constant within a small range
MSE_sta = [mean(mean(E_all_001(:,400:end).^2,2));mean(mean(E_all_005(:,400:end).^2,2))];
Mis_estimate = (MSE_sta - sigma) / sigma; % Mis_estimate(1) for 0.01 step size

% The theoretical Misadjustment M_LMS = u/2 * Trace(R)
M_LMS = (miu/2) * trace(R1);

sprintf("The estimated Misadjustment for step_size=0.01 is %1.5f \n step_size=0.05 is %1.5f",Mis_estimate(1),Mis_estimate(2))

sprintf("The theoretical Misadjustment for step_size=0.01 is %1.5f \n step_size=0.05 is %1.5f",M_LMS(1),M_LMS(2))

%% Task d
Avg_W_001_sta = mean(Avg_W_001(:,400:end),2);
Avg_W_005_sta = mean(Avg_W_005(:,400:end),2);

sprintf("The estimated weight for step_size=0.01 is a1=%1.5f , a2=%1.5f",Avg_W_001_sta(1),Avg_W_001_sta(2))

sprintf("The estimated weight for step_size=0.05 is a1=%1.5f , a2=%1.5f",Avg_W_005_sta(1),Avg_W_005_sta(2))

% The abs(error) and MSE of weight
% abs weight error
weight_error_001 = abs(Avg_W_001_sta.'-coefficient);
weight_error_005 = abs(Avg_W_005_sta.'-coefficient);
% MSE weight
MSE_weight_001 = weight_error_001.^2;
MSE_weight_005 = weight_error_005.^2;

sprintf("The abs error for step_size=0.01 is %1.5f and %1.5f ",weight_error_001(1),weight_error_001(2))
sprintf("The abs error for step_size=0.05 is %1.5f and %1.5f ",weight_error_005(1),weight_error_005(2))

sprintf("The MSE for step_size=0.01 is %1.5f and %1.5f ",MSE_weight_001(1),MSE_weight_001(2))
sprintf("The MSE for step_size=0.05 is %1.5f and %1.5f ",MSE_weight_005(1),MSE_weight_005(2))

%%





