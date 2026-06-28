
%% Least Mean Squared Algorithm (LMS) for AR(2) signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%
% - x(1*(N_sample+N_c), complex) = input signal (AR)
%
% - miu (1x1 double) = The step size
%
% - N_c (1x1 double) = The number of coefficient
%
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%
% - e (1*N_sample double) = The estimated error
%
% - w_all (N_c*N_sample) = All weights for LMS process
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



function [e,w_all]=LMS_AR2(x,miu,N_c)

    N_sample = length(x);
    % Initlise the weight w
    w = zeros(N_c,1); % The number of weight should be the same as the coefficient
    w_all = [];

    % Adaption
    for n = 1+N_c:N_sample
        
        % previous two data
        x_n = [x(n-1);x(n-2)];
    
        % Error = true - estimate
        e(n) = x(n) - w' * x_n;
    
        % update the weight
        w = w + miu*e(n)*x_n;
    
        % Store all the weight
        w_all = [w_all,w];
    end

end