%% MA(1) LMS GNGD function, gegularised Normalised LMS
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Inpur
% - N_coeff (1x1 double) = The length of Number of coefficient
% - N (1X1 double) = The number of sample
% - x (1*N) = The MA signal
% - noise (1*N) = The noise, input signal
% - mu_initilise (1x1 double) = The initilise step size
% - type (1x1 string) = The step size type (B = Benveniste) (A = Ang & Farhang)
%                                          (M = Mattew)
% - rho (1x1 double) = The step size change
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Output:
% - w (N_coeff*(N+N_coeff)) = The estimate weight
% - e (1*N) = The error
%
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function [w,e]=LMS_GNGD(N_coeff,N,x,noise,rho,mu_initilise)
    %% Perfrom the GNGD Regularised NLMS
    % Need to initilise the weight
    w = zeros(N_coeff,N+N_coeff);
    % initilise the error
    e = zeros(1,length(x));
    epsion = zeros(1,length(x));
    % need to initilise the factor
    epsion(2) = 0.1;
    % LMS
    for i = 2+N_coeff:length(x)
                % weight
                w_n = w(:,i);
                % Teaching signal
                d = x(i);
                % sample data
                x_n = noise(i-N_coeff:i-1);
                x_n_1 = noise(i-N_coeff-1:i-2);
                % error
                e(i) = d - w_n'*x_n;
                epsion_n_1 = epsion(i-1);
                
                % update the regularised factor
                epsion(i) = epsion_n_1 - rho * mu_initilise * ( e(i)*e(i-1)*x_n'*x_n_1 )/( epsion_n_1 + x_n'*x_n )^2;

                % Update thw weight
                w(:,i+1) = w_n + mu_initilise / ( epsion(i) + x_n' * x_n ) * e(i)*x_n;
    
    end
end
