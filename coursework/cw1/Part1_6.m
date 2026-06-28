clc
clear
close all;
addpath("function\");
addpath("PCR\")
load("PCR\PCAPCR.mat");
orange = [0.8500 0.3250 0.0980];
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels
%%
[N,Num_c]= size(X);
[xU,xD,xV] = svd(X);
[xnoise_U,xnoise_D,xnoise_V] = svd(Xnoise);

figure() % plot for the singular value of X and X_noise
subplot(3,1,1) % from the first plot, it can used to identify the rank of the signal X
% since there is only 3 non-zero values exist in the singular value of X in
% this plot, then the signal X only hvae rank of 3
stem(diag(xD),'Color',orange,"LineWidth",1.5);grid on;
title("Singular Values of X");xlabel("Variable [Column]");ylabel("Magnitude")
subplot(3,1,2) % Therefore, from this plot where the signal X is added with the NOise which have zero mean,
% the plot show there is more than 3 non-zeros values. then noise can be
% used to increase the rank of the signal x from rank 3 to full rank in
% this case.
stem(diag(xnoise_D),'Color',orange,"LineWidth",1.5);grid on;
title("Singular Values of $X_{noise}$");ylabel("Magnitude")
xlabel("Variable [Column]");

% X have rank of 3
% but X_noise has full rank of 10

%% square error
subplot(3,1,3)
sq_error = diag(xD-xnoise_D).^2;
stem(sq_error,'Color','k',"LineWidth",1.5);grid on;
title("Square Error of $X$ and $X_{noise}$");
xlabel("Variable [Column]");ylabel("Magnitude")


%% compute the estimate X_denoted
rank_X = rank(X);
% compute the X from thre X noise since we know the rank of the X is 3,
% then only take the rank 1-3 from the U,S,V from the svd of X_noise
X_denoise = xnoise_U(:,1:rank_X)*xnoise_D(1:rank_X,1:rank_X)*xnoise_V(:,1:rank_X).';
% xnoise_U(:,1:rank_X) have size of 1000x3
% xnoise_D(1:rank_X,1:rank_X) have size of  3x3
% xnoise_V(:,1:rank_X) have size of 10x3, therefore, need to change it to
% 3x10
[U_denoise,S_denoise,V_denosie] = svd(X_denoise);
figure()
subplot(2,1,1)
stem(diag(S_denoise),'Color',orange,"LineWidth",1.5);grid on;
title("Singular Values of $X_{denosie}$");
xlabel("Variable [Column]");ylabel("Magnitude")

%% compare the error
error_X_X_denoise = mean((X-X_denoise).^2);
error_X_X_noise =   mean((X-Xnoise).^2);

subplot(2,1,2) % plot of mean square error
stem(error_X_X_noise,'Color','k',"LineWidth",1.5);grid on;
hold on;
stem(error_X_X_denoise,'Color',orange,"LineWidth",1)
legend("$X_{noise}$","$X_{denoise}$");title("Mean Square Error of each variable in X");
xlabel("Variable [Column]");ylabel("Magnitude")

%% Ordianry least squares (OLS), estimate the B martic since it is unknow
B_OLS = inv(Xnoise'*Xnoise)*(Xnoise'*Y);

% estimate of Y
Y_OLS = Xnoise*B_OLS;

%% Principle Componment Regression (PCR), estimate the B martic since it is unknow
B_PCR = xnoise_V(:,1:rank_X)*inv(xnoise_D(1:rank_X,1:rank_X))*xnoise_U(:,1:rank_X).'*Y;

% estimate of Y
Y_PCR = X_denoise*B_PCR;

%% Compare the mean square error of Y and Y_PCR and Y_OLS
error_OLS = mean(mean((Y - Y_OLS).^2));
error_PCR = mean(mean((Y - Y_PCR).^2));

%% Y test
[U_test,S_test,V_test] = svd(Xtest);
X_denoise_test = U_test(:,1:rank_X)*S_test(1:rank_X,1:rank_X)*V_test(:,1:rank_X).';

% estimation of Y
Y_test_OLS = Xtest*B_OLS;
Y_test_PCR = X_denoise_test * B_PCR;

% compare the error of Ytest,Ytest_OLS,Ytest_PCR
error_OLS_test = mean(mean((Ytest - Y_test_OLS).^2));
error_PCR_test = mean(mean((Ytest - Y_test_PCR).^2));

%% Training
for i = 1:2000
    [Y_estimate_OLS,Y_new_OLS] = regval(B_OLS);
    error_OLS_new(i) = mean(mean(((Y_new_OLS-Y_estimate_OLS).^2)));

    [Y_estimate_PCR,Y_new_PCR] = regval(B_PCR);
    error_PCR_new(i) = mean(mean(((Y_new_PCR-Y_estimate_PCR).^2)));
end
% mean sqaure error comparesion of all data set comparsion
avg_error_OLS = mean(error_OLS_new);
avg_error_PCR = mean(error_PCR_new);


