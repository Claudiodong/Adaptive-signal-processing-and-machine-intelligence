
%% AR(2) signal generator
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%
% - coefficient (1*N_c, double) =Coefficient for the AR signal
%
% - N_sample (1*1 double) = The number of sample
%
% - sigma (1x1 double) = The noise power value
%
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%
% - w (1*N_sample complex) = The AR signal
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


function [x]=AR_generator(coefficient,N_sample,sigma)
    % Flip the coefficient      
    flip_coe = flip(coefficient);

    % The length of the coefficient
    N_c = length(flip_coe);

    % Predefine the signal length
    x = zeros(N_sample+N_c,1);

    % Generate the AR signal
    for i = 1+N_c:N_sample+N_c
       x(i) = flip_coe*x(i-2:i-1) + sqrt(sigma)*randn(1,1);
    end

end
