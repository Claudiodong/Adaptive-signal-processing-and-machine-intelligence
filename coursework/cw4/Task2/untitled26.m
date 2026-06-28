clc
clear
close all;

% input signal
x = [-0.18,-0.28,-0.23,-0.32,0.45,0.45,0.45,-0.35].';

% initilise the weights
w1 = [-0.07,-0.01,-1.47].';
w2 = [0.44,0.14,-0.30].';
w3 = [1.15,-1.01,-1.83].';

% Parameter
N = 8;
M = 3;
K = 3;

% first convolution with no biased
y1 =circular_convolution(N,M,w1,x,0);
y2 =circular_convolution(N,M,w2,x,0);
y3 =circular_convolution(N,M,w3,x,0);

% nonlinear activation function
fy1=ReLU(y1);
fy2=ReLU(y2);
fy3=ReLU(y3);

% max-pooling P=3, select the data with 3 per group, and select the max
% value among the group
P = 3;
[max_value1]=max_pooling(fy1,P);
[max_value2]=max_pooling(fy2,P);
[max_value3]=max_pooling(fy3,P);

% flattening



function [result]=circular_convolution(N,M,w,x,b)
        % perform convolution
        result = zeros(N-M+1,1);
        for i = 1:N-M+1
           result(i) = w'*x(i:i+2) + b;
        end
end


function [y]=ReLU(x)
    
    y = zeros(length(x),1);
    for i = 1:length(x)
        y(i) = max(0,x(i));
    end

end


function [max_value]=max_pooling(x,P)
    
    Int = floor(length(x)/P);
    max_value = zeros(Int,1);
    for i = 1:Int
        start =  1 + 3*(i-1);
        ending = (i)*P ;
        group = x(start:ending);
        max_value(i) = max(group);
    end
end
