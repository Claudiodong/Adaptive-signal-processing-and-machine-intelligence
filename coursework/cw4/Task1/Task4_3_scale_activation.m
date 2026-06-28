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
% remove the mean, AR(4) data
y_no_mean = y - mean(y);
%%%%%%%%%%%%%%%%%%%%
a = 0:10:100;
%%%%%%%%%%%%%%%%%%%%%%

MSE = zeros(1,length(a));
ga = zeros(1,length(a));
for j = 1:length(a)

%     % use the LMS order of (4)
%     w = zeros(M,length(y_no_mean));
%     y_hat = zeros(1,length(y_no_mean));
%     e = zeros(1,length(y_no_mean));
% 
%     % LMS
%     for i = 1+M:length(y_no_mean)
%         % the input x_n
%         x_n = flip(y_no_mean(i-M:i-1));
% 
%         % activation function tanh function(x'x)
%         y_hat(i) = a(j)*tanh(w(:,i)'*x_n); % estimation
% 
%         % error
%         e(i) = y_no_mean(i) - y_hat(i);
% 
%         % update the weight
%         w(:,i+1) = w(:,i) + mu*e(i)*x_n;
%     end
    
    [e,y_hat,w]=activation_LMS(y_no_mean,M,a(j),mu);
    % MSE error
    MSE(j) = mean((e).^2);
    
    % prediction gain
    variance_of_output = mean(y_hat.^2) - mean(y_hat)^2;
    variance_of_error = mean(e.^2) - mean(e)^2;

   ga(j)= 10*log10(variance_of_output/variance_of_error);
end

figure()

plot(a,ga,'-x','LineWidth',3,'MarkerSize',10);xlabel("Scaling $a$",'FontSize',12);
ylabel("Prediction Gain $R_{p}$ [dB]",'FontSize',12);
grid on

figure()
plot(a(2:end),10*log10(MSE(2:end)),'-X','LineWidth',2.5,'MarkerSize',10);
xlabel("Scaling $a$",'FontSize',12);ylabel("MSPE [dB]",'FontSize',12);
grid on;

max(abs(y_no_mean))


%% optimal scaling a is 80
[~,y_hat_optimal,w_20]=activation_LMS(y_no_mean,M,80,mu);

figure() % scaling with 80
plot(y_hat_optimal,'-','LineWidth',1);
hold on;
plot(y_no_mean,'-')
legend("Optimal predicted signal $\hat{y}(n)$","Actual Signal $y(n)$");
xlabel("Sample [n]",'FontSize',12);ylabel("Magnitude",'FontSize',12);title("Dynamical preceptron with sacling $a=80$",'FontSize',12);
grid on;

[~,y_hat_20,~]=activation_LMS(y_no_mean,M,20,mu);

figure() % scaling with 20
plot(y_hat_20,'-','LineWidth',1);
hold on;
plot(y_no_mean,'-')
legend("predicted signal $\hat{y}(n)$","Actual Signal $y(n)$");
xlabel("Sample [n]",'FontSize',12);ylabel("Magnitude",'FontSize',12);title("Dynamical preceptron with sacling $a=20$",'FontSize',12);
grid on;

figure() % weight estimation
plot(w_20(1,:))
hold on;
plot(w_20(2,:))
hold on;
plot(w_20(3,:))
hold on;
plot(w_20(4,:))


