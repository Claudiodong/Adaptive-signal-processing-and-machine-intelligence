% Claudio Dong Imperial College London 2/5/2024
%
% This function is used to produce the unbiased autocorrelation function
% coefficient
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Input
% - y = input signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Output
% - ACF = Autocorrelation Function
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function [ACF,k] = unbiased_ACF(y)
    % The number of samples in the signal
    Num_sample = length(y);
    k = 1:Num_sample;
    ACF = zeros(1, Num_sample-1);    
    % Loop over all possible lags from 0 to Num_sample-1
    for K = 0:Num_sample-1 % lag k
        sum_sample = 0;
        
        for n = K+1:Num_sample % sample n
            sum_sample = sum_sample + y(n) * conj(y(n-K));
        end
        ACF(K+1) = sum_sample /(Num_sample - K) ;
    end
end