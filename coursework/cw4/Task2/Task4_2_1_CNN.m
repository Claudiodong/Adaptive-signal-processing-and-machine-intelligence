clc
clear
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

%%
% generate the signal
t = ((2*pi)/100):((2*pi)/100) : 10*pi;
y1 = sin(t);
y2 = sin(0.5*t);
y3 = sin(4*t);

% signal plot
figure()
% subplot(3,1,1)
plot(y1,'--','LineWidth',1);
xlabel("Sample [n]",'FontSize',13);ylabel("Magnitude",'FontSize',13);
% title("$y_{1}$",'FontSize',13)
hold on;
% subplot(3,1,2)
plot(y2,'-.','LineWidth',1);
% xlabel("Sample [n]",'FontSize',13);ylabel("Magnitude",'FontSize',13);
% title("$y_{2}$",'FontSize',13)
hold on;
% subplot(3,1,3)
plot(y3,'LineWidth',1);
% xlabel("Sample [n]",'FontSize',13);ylabel("Magnitude",'FontSize',13);
% title("$y_{3}$",'FontSize',13)
legend("$y_{1}$","$y_{2}$","$y_{3}$")


%% convolution result
A = conv(y1,y1,'same');
mean_value = mean(abs(A));
max_value = max(abs(A));
B = conv(y1,y2,"same");
C = conv(y1,y3,"same");

% convolution plot
figure()
plot(A,'LineWidth',1);
hold on;
plot(B,'LineWidth',1);
hold on;
plot(C,'LineWidth',1);
legend("Auto-convolution $y_{1}$",'Convolution $y_{1},y_{2}$','Convolution $y_{1},y_{3}$','FontSize',12);
grid on;ylabel("Magnitude",'FontSize',13);xlabel("Sample [n]",'FontSize',13)

%% classification
% 
% % store the information
% AA = conv(y1,y1,"same");
% BB = conv(y2,y2,"same");
% CC = conv(y3,y3,"same");
% 
% figure()
% plot(AA);
% hold on;
% plot(BB);
% hold on;
% plot(CC)

% input signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = y3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Classification(y1,y2,y3,x)

%% classification function
function Classification(y1,y2,y3,x)

    conv_A = conv(x,y1,"same");
    conv_B = conv(x,y2,"same");
    conv_C = conv(x,y3,"same");
    
    % Apply the abs, simialr to non-linear function
    abs_A = abs(conv_A);
    abs_B = abs(conv_B);
    abs_C = abs(conv_C);
    
    % Apply the max_pooling use max-operator
    max_A = max(abs_A);
    max_B = max(abs_B);
    max_C = max(abs_C);
    
    % Apply the mean, 
    mean_A = mean(abs_A);
    mean_B = mean(abs_B);
    mean_C = mean(abs_C);

    [~,index_max]=max([max_A,max_B,max_C]);
    [~,index_mean] = max([mean_A,mean_B,mean_C]);

    if (index_max == index_mean)
        sprintf("The Input signal is y_{%1.0f}",index_mean)
    end
end



