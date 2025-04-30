
%% MA(1) LMS Gass function, which inclding the step size change in the function
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%
% - N_coeff (1x1 double) = The length of Number of coefficient
% - N (1X1 double) = The number of sample
% - x (1*N) = The MA signal
% - n (1*N) = The noise, input signal
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

function [w,e]=MA_1_Gass_function(N_coeff,N,x,n,mu_initilise,type,rho)

        % Need to initilise the weight
        w = zeros(N_coeff,N+N_coeff);
        % initilise the step size
        mu = zeros(1,length(x));
        mu(3) = mu_initilise; % need to put in correct location, otherwise it will be replaced
        % initilise the error
        e = zeros(1,length(x));
        % initilise the phi 
        phi = zeros(1,length(x));
        
        % LMS
        for i = 2+N_coeff:length(x)
            % weight
            w_n = w(:,i);
        
            % Teaching signal
            d = x(i);
        
            % sample data
            x_n = n(i-N_coeff:i-1);
        
            % current step size
            mu_n = mu(i);
        
            % error
            e(i) = d - w_n'*x_n;
        
            % Update thw weight
            w(:,i+1) = w_n + mu_n*e(i)*x_n;
        
            % x(n-1)
            x_n_1 = flip(n(i-N_coeff-1:i-2));
        
            if strcmp(type, 'B')
                %% Benveniste method
                % Update the step size based on the method
                phi(:,i) = ( eye(N_coeff) - mu(i-1)*(x_n_1 * x_n_1') ) * phi(:,i-1) + e(i-1)*x_n_1;

  
                % update
                %mu(i+1) = mu_n + rho * e(i) * x_n * phi(:,i); 
            elseif strcmp(type, 'A') 
                %% Ang & Farhang method
                alpha = 0.5;
                phi(:,i) = alpha*phi(:,i-1) + e(i-1)*x_n_1;


                % update
                %mu(i+1) = mu_n + rho * e(i) * x_n * phi(:,i); 
            elseif strcmp(type, 'M') 
                %% Matthews method
                phi(:,i) = e(i-1)*x_n_1;


                % update 
                %mu(i+1) = mu_n + rho * e(i) * x_n * phi(:,i); 
            else % if not method select, then keep the step size constant
                phi(:,i) = 0;
            end    % end of type selection

            % update 
            mu(i+1) = mu_n + rho * e(i) * x_n * phi(:,i); 
        end % end of LMS loop
end