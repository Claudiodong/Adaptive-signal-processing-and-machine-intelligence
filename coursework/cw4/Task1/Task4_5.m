clc
clear 
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

load("time-series.mat")

M = 4;
a = 50; % optimal a for the biased LMS
mu = 1e-5;
epochs = 100;

pre_w = zeros(M+1,1);
for j = 1:epochs
    % pretrain the first 20 sample 
    % consider the unbised method with no-mean signal
    for i = 1+M:20
        x_n = flip(y(i-M:i-1));
        x_n = [1;x_n];
        y_hat(i) = a*tanh(pre_w'*x_n);
        e(j,i) = y(i) - y_hat(i);
        pre_w = pre_w+ mu*e(j,i)*x_n;
    end  
end
% 
figure()
plot(y_hat);
hold on;
plot(y(1:20));


%%

% use the pre-train data as initilisation
w = zeros(M+1,length(y));
w(:,5) = pre_w;
for i = 1+M:length(y)
     x_n = flip(y(i-M:i-1));
     x_n1 = [1;x_n];
     y_hat_final(i) = a*tanh(w(:,i)'*x_n1);
     e_final(i) = y(i) - y_hat_final(i);
     w(:,i+1) = w(:,i)+ mu*e_final(i)*x_n1;
end

w = w(:,M+1:end);
% weight esimation
figure()
for i = 1:5
plot(w(i,:),'LineWidth',1);
hold on;
end
xlabel("Sample [n]",'FontSize',12);ylabel("Weight estimation",'FontSize',12)
legend("$w_{1}$","$w_{2}$","$w_{3}$","$w_{4}$","$w_{5}$",'FontSize',12);grid on;

%%
% MSE error
MSE =10*log10( mean((e_final).^2));

% prediction gain
variance_of_output = mean(y_hat_final.^2) - mean(y_hat_final)^2;
variance_of_error = mean(e_final.^2) - mean(e_final)^2;

ga= 10*log10(variance_of_output/variance_of_error);

% have better performance, since the pre-trained weight reduce the first 20
% samples prediction error and speed up the covergence, but afterward
% performance is the same
figure()
plot(y_hat_final,'LineWidth',1);
hold on;
plot(y,'LineWidth',1);
legend("predicted signal $\hat{y}(n)$","Actual Signal $y(n)$",'FontSize',12);
title("Prediction with pre-trained weight",'FontSize',12);xlabel("Sample [n]",'FontSize',12);ylabel("Magnitude",'FontSize',12);

mean(y_hat_final)
