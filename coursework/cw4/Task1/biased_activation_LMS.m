

% LMS with biased activation function to predict the non-linear signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% y_no_mean (1*L double) = zero-mean signal
% M  (1x1 double)= filter order or signal order
% a (1x1 double) = scaling factor for the activation function
% mu (1x1 double) = step size for the LMS algorithm
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [e,w,y_hat]=biased_activation_LMS(y,mu,a,M)
 % use the LMS order of (4)
    w = zeros(M+1,length(y)); % the extra +1 due to the biased
    y_hat = zeros(1,length(y));
    e = zeros(1,length(y));

    % LMS
    for i = 1+M:length(y)
        % the input x_n
        x_n1 = flip(y(i-M:i-1));
        x_n = [1;x_n1]; % adding extra x_n, and extra weight, where the b =1
        % activation function tanh function(x'x)
        y_hat(i) = a*tanh(w(:,i)'*x_n); % estimation

        % error
        e(i) = y(i) - y_hat(i);

        % update the weight
        w(:,i+1) = w(:,i) + mu*e(i)*x_n;

    end
end