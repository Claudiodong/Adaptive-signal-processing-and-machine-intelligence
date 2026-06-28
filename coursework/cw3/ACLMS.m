%% Perform Arugumented Complex LMS(ACLMS) algorithm 
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% M (1x1 double)= filter order
% y (1xL double) = input signal
% x (1xL double) = circular noise
% mu (1x1 double) = step size
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [e,h,g]=ACLMS(M,y,x,mu)
    L = length(y);
    e = zeros(1,L);
    %% Apply the ACLMS
    h = zeros(M,L);
    g = zeros(M,L);
    for i = 1+M:length(y)
        x_n = flip(x(i-M:i-1));
        esti_y = h(:,i)'*x_n + g(:,i)'*conj(x_n);
        e(i) = y(i) - esti_y;
        h(:,i+1) = h(:,i) + mu*conj(e(i))*x_n;
        g(:,i+1) = g(:,i) + mu*conj(e(i))*conj(x_n);
    end
    h = h(:,M+1:end);
    g = g(:,M+1:end);
    e = e(M+1:end);
end
