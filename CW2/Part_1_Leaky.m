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
N_sample = 1000;         % The number of sample
N_c = length(coefficient); % The length of the coefficient
Max = 200;

[x]=AR_generator(coefficient,N_sample,sigma);

% leaky coefficient
gamma = [0.01,0.05,0.1,0.5,0.8];
% step size
miu = [0.01,0.05];

figure()
for i = 1:length(gamma)
    all_weight_a1 = 0;
    all_weight_a2 = 0;
    for i_max = 1:Max
    [e,w_all]=Leaky_LMS_AR2(x,miu(2),gamma(i),N_c);
    
    all_weight_a1 = all_weight_a1+ w_all(1,1:end);
    all_weight_a2 = all_weight_a2+ w_all(2,1:end);
    end
    Avg_weight_a1 = all_weight_a1 ./ Max;
    Avg_weight_a2 = all_weight_a2 ./ Max;

    plot(1:length(w_all),Avg_weight_a2,'LineWidth',1);
    hold on;
end
grid on;
xlabel("Sample Number [n]");ylabel("Weight evolution for $a_2$",'FontSize',12);
ylim([0,1]);
hold on;
plot(1:N_sample,coefficient(2)*ones(1,N_sample),'--','LineWidth',2)
legend("$\gamma=0.01$","$\gamma=0.05$","$\gamma=0.1$","$\gamma=0.5$","$\gamma=0.8$","True weight",'FontSize',8)



% For constant step size, increase gamma will lead to wrong estimation on
% the coefficient