clc
clear 
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

load("time-series.mat")
%%%%%%%%%%%%%%%%%
mu = 1e-5;
M = 4;
%%%%%%%%%%%%%%%%
% remove the mean, AR(4) data
y_no_mean = y - mean(y);

% % use the LMS order of (4)
% w = zeros(M,length(y_no_mean));
% for i = 1+M:length(y_no_mean)
%     x_n = flip(y_no_mean(i-M:i-1));
%     % activation function tanh function(x'x)
%     y_hat(i) = tanh(w(:,i)'*x_n);
%     e(i) = y_no_mean(i) - y_hat(i);
%     w(:,i+1) = w(:,i) + mu*e(i)*x_n;
% end
[e,y_hat,w]=activation_LMS(y_no_mean,M,1,mu); % no scaling

figure()
plot(y_hat,'-','LineWidth',1);
hold on;
plot(y_no_mean,'-')
legend("Predicted signal $\hat{y}(n)$","Actual Signal $y(n)$");
xlabel("Sample [n]",'FontSize',12);ylabel("Magnitude",'FontSize',12);title("Dynamical preceptron",'FontSize',12)

% MSE error
MSE = 10*log10(mean((e).^2));

% prediction gain
variance_of_output = mean(y_hat.^2) - mean(y_hat)^2;
variance_of_error = mean(e.^2) - mean(e)^2;
ga = 10*log10(variance_of_output/variance_of_error);