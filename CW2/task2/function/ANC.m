%% ANC adaptive noise cancellation, which adapte the noise, and error is the estimate pure signal
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Inpur
% - Max (1x1 double) = The number of monte carlo
% - L (1X1 double) = The number of sample
% - mu (1*N) = The step size
% - N_coeff (1*N) = The order of the filter 
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Output:
% - x (L*1) = pure signal (desired signal wanted)
% - avg_e (L*1) = average error signal (which is the pure signal is ANC)
% sicne e = d - estimate noise
% - MPSE (1*1) = mean squared prediction error
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function  [x,avg_e,MPSE]=ANC(Max,L,mu,N_coeff)
         e = zeros(L,Max);
        % ANC process
        MSPE_all = 0;
        for max = 1:Max
                n = randn(1,L);
                color_noise = zeros(L+2,1);
                % MA color noise
                 for i = 3:L
                     color_noise(i) = n(i) + 0.5*n(i-2);
                 end
                 color_noise = color_noise(3:end);
        
                 % pure signal
                 x = sin(0.01*pi*(1:L)).';
                    
                 % signal
                s = x + color_noise;
                
                % secondary noise should have size L*1
                sec_noise = 0.6*color_noise + 0.2*randn(L,1);
        
                w = zeros(N_coeff,1); % define the weight should be M*1 size
        
                for j = 1+N_coeff:length(sec_noise)
                    u = flip(sec_noise(j-N_coeff+1:j)); % the u
                    noise_hat = w'*u;                % estimate noise
                    x_hat = s(j) - noise_hat;        % the error 
                    e(j,max) = x_hat;
                    % update the weight
                    w = w + mu* x_hat * u;
                end
                x = x(N_coeff+1:end);
                MSPE_all = sum((x-e(N_coeff+1:end,max)).^2)/ length(x) + MSPE_all;
        end
        
        % average error
        avg_e = mean(e,2);
        avg_e = avg_e(N_coeff+1:end);
        
        
        MPSE = MSPE_all/Max;
end

