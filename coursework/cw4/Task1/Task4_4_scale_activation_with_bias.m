clc
clear 
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

load("time-series.mat")
mu = 1e-5;
M = 4;
y_no_mean = y - mean(y);
%%%%%%%%%%%%%%%%%%%%
a = 0:10:100;
%%%%%%%%%%%%%%%%%%%%%%

MSE = zeros(1,length(a));
ga = zeros(1,length(a));
for j = 1:length(a)

    [e,w,y_hat]=biased_activation_LMS(y,mu,a(j),M);
  
    % MSE error
    MSE(j) = mean((e).^2);
    
    % prediction gain
    variance_of_output = mean(y_hat.^2) - mean(y_hat)^2;
    variance_of_error = mean(e.^2) - mean(e)^2;

   ga(j)= 10*log10(variance_of_output/variance_of_error);
end


figure() % error plot and gain
plot(a,ga,'-x','LineWidth',3,'MarkerSize',10);xlabel("Scaling $a$",'FontSize',12);
ylabel("Prediction Gain $R_{p}$ [dB]",'FontSize',12);
grid on

figure()
plot(a,10*log10(MSE),'-X','LineWidth',2.5,'MarkerSize',10);
xlabel("Scaling $a$",'FontSize',12);ylabel("MSPE [dB]",'FontSize',12);
grid on;

%% comparsion
[~,~,y_hat_biased]=biased_activation_LMS(y,mu,50,M);
[~,y_hat_unbiased,~]=activation_LMS(y_no_mean,M,50,mu);
mean(y_hat_biased)


% biased and unbiased comparesion
figure()
plot(y_hat_biased,'-','LineWidth',1);
hold on;
plot(y);
legend("predicted signal $\hat{y}(n)$","Actual Signal $y(n)$");
title("Biased",'FontSize',12);xlabel("Sample [n]",'FontSize',12);ylabel("Magnitude",'FontSize',12);

figure()
plot(y_hat_unbiased,'-','LineWidth',1);
hold on;
plot(y);
legend("predicted signal $\hat{y}(n)$","Actual Signal $y(n)$");
title("Unbiased",'FontSize',12);xlabel("Sample [n]",'FontSize',12);ylabel("Magnitude",'FontSize',12);

%% weight plot
[~,w,~]=biased_activation_LMS(y,mu,50,M);
w = w(:,2:end);

figure()
for i = 1:5
    plot(w(i,:),'LineWidth',1.5);
    hold on;
end
xlabel("Sample [n]",'FontSize',13);ylabel("Weight Estimation",'FontSize',13);grid on;
legend("$w_{1}$","$w_{2}$","$w_{3}$","$w_{3}$","$w_{5}$",'FontSize',13)

