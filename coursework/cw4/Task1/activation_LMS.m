

% LMS with activation function to predict the non-linear signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% y_no_mean (1*L double) = zero-mean signal
% M  (1x1 double)= filter order or signal order
% a (1x1 double) = scaling factor for the activation function
% mu (1x1 double) = step size for the LMS algorithm
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function [e,y_hat,w]=activation_LMS(y_no_mean,M,a,mu)

        % use the LMS order of (4)
        w = zeros(M,length(y_no_mean));
        y_hat = zeros(1,length(y_no_mean));
        e = zeros(1,length(y_no_mean));
    
        % LMS
        for i = 1+M:length(y_no_mean)
            % the input x_n
            x_n = flip(y_no_mean(i-M:i-1));
    
            % activation function tanh function(x'x)
            y_hat(i) = a*tanh(w(:,i)'*x_n); % estimation
    
            % error
            e(i) = y_no_mean(i) - y_hat(i);
    
            % update the weight
            w(:,i+1) = w(:,i) + mu*e(i)*x_n;
        end
end