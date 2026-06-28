%% ALE adaptive line enhancer, which adapte the desired signal, and the error is the noise
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Inpur
% - Max (1x1 double) = The number of monte carlo
% - L (1X1 double) = The number of sample
% - mu (1*N) = The step size
% - N_coeff (1*N) = The order of the filter 
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Output:
% - x (L*1) = pure signal (desired signal wanted)
% - x_hat_avg (L*1) = The estimate pure signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [x,x_hat_avg,MSPE] = ALE(N_coeff,L,mu,delta,Max)
       
        x_hat = zeros(L,Max);
        for max = 1:Max
                n = randn(1,L+N_coeff);
                color_noise = zeros(L+2,1);
                % MA color noise
                 for i = 3:L
                     color_noise(i) = n(i) + 0.5*n(i-2);
                 end
                    
                 color_noise = color_noise(3:end);
                 % pure signal
                 x = sin( 0.01*pi*(1:L)).';
                    
                 % signal
                s = x + color_noise;
                
                w = zeros(N_coeff,1);
                % Adaptive linear enhancer part
                for j = (N_coeff + delta) : L
                   A = j- delta - N_coeff +1;
                   B = j - delta;
                   u = flip(s(A:B));
                   x_hat(j,max) = w'*u;
                   e = s(j) - x_hat(j,max);
                   w = w + mu*e*u;
                end  

           x = x(N_coeff:end-delta);
           MSPE_all(max,:) = (x - x_hat(delta+N_coeff:end,max)).^2;
        end
        
        %%

        x_hat_avg = mean(x_hat,2);
        x_hat_avg = x_hat_avg(delta+N_coeff:end);
        MSPE = mean(mean(MSPE_all,1));
end