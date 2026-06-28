

%% Perform Complex LMS(CLMS) algorithm 
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% M (1x1 double)= filter order
% y (1xL double) = input signal
% x (1xL double) = circular noise
% mu (1x1 double) = step size
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [e_clms,h_clms]=CLMS(M,y,x,mu)
    L = length(y);
    h_clms = zeros(M,L);
    e_clms = zeros(1,L);
    for i = 1+M:length(y)
        x_n = flip(x(i-M:i-1));
        
        est_y_clms = h_clms(:,i)'*x_n; % estimate the y

        e_clms(i) = y(i) - est_y_clms; % error

        % update the weight
        h_clms(:,i+1) = h_clms(:,i) +  mu* conj(e_clms(i)) * x_n;
    end
    h_clms = h_clms(:,M+1:end);
    e_clms = e_clms(M+1:end);
end