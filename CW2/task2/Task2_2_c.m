clc
clear
close all;
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

% MA(1),generate the signal
N = 1500;                           % The number of sample
N_coeff = 1;                        % The number of coefficient
coefficient = 0.9;
x = zeros(1,N_coeff+N);
mu_initilise = [0.1,0.01];          % initilise the step size
rho = 0.0003;                       % the change in step size
Max = 200;                          % Number of iteration
addpath("function_task2\")

w_GNGD_001 = zeros(Max,length(x)+1);
w_B_001 = zeros(Max,length(x)+1);
w_GNGD_01 = zeros(Max,length(x)+1);
w_B_01 = zeros(Max,length(x)+1);
for j = 1:Max
 % Generate the MA(1) signal
 n = 1/sqrt(2) * randn(1,N+N_coeff);
 for i = 1+N_coeff:N+N_coeff
      x(i) = coefficient*n(i-1) + n(i);
 end
%% Perfrom the GNGD Regularised NLMS
% LMS
% for i = 2+N_coeff:length(x)
%             % weight
%             w_n = w(:,i);
%             % Teaching signal
%             d = x(i);
%             % sample data
%             x_n = n(i-N_coeff:i-1);
%             x_n_1 = n(i-N_coeff-1:i-2);
%             % error
%             e(i) = d - w_n'*x_n;
%             epsion_n = epsion(i);
%             % Update thw weight
%             w(:,i+1) = w_n + mu_initilise(2) / ( epsion_n + x_n' * x_n ) * e(i)*x_n;
% 
%             % update the regularised factor
%             epsion(i+1) = epsion_n - rho*mu_initilise(2)*(e(i)*e(i-1)*x_n'*x_n_1)/( epsion(i-1) + x_n'*x_n )^2;
% end
%         
[w_GNGD_001(j,:),~]=LMS_GNGD(N_coeff,N,x,n,rho,mu_initilise(2));
[w_B_001(j,:),~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(2),"B",rho);

[w_GNGD_01(j,:),~]=LMS_GNGD(N_coeff,N,x,n,rho,mu_initilise(1));
[w_B_01(j,:),~]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise(1),"B",rho);

end
% Average weight
Avg_w_GNGD_001 = mean(w_GNGD_001,1);
Avg_w_B_001 = mean(w_B_001,1);

Avg_w_GNGD_01 = mean(w_GNGD_01,1);
Avg_w_B_01 = mean(w_B_01,1);

%%
figure
plot(1:N+2,Avg_w_GNGD_001);
hold on;
plot(1:N+2,Avg_w_B_001)
legend("GNGD $\mu$=0.01","Benveniste $\mu$(0)=0.01",'Location','best');
xlim([1,N+2]);grid on;
xlabel("Sample Number");ylabel("Estimated Weight")

figure
plot(1:N+2,Avg_w_GNGD_01);
hold on;
plot(1:N+2,Avg_w_B_01)
legend("GNGD $\mu$=0.1","Benveniste $\mu$(0)=0.1",'Location','best');
xlim([1,N+2]);grid on;
xlabel("Sample Number");ylabel("Estimated Weight")
