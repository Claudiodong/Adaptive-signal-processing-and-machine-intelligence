clc
clear
close all
% Set the default for all text to use LaTeX interpreter
set(0, 'defaultTextInterpreter', 'latex');          % For text
set(0, 'defaultLegendInterpreter', 'latex');        % For legends
set(0, 'defaultAxesTickLabelInterpreter', 'latex'); % For tick labels

%%
L = 1500;   % sample length
M = 1;      % order of filter
mu = 0.001; % step size
Max = 200;

% coefficient for WLMA model
b1 = 1.5 + 1i;
b2 = 2.5 - 0.5*1i;

e_clms_avg = 0;
e_aclms_avg = 0;
for i_max = 1:Max
    % noise 
    x_noise = (randn(L,1) + 1i* randn(L,1) )/sqrt(2);
    % WLMA
    y = zeros(L,1);
    for i = 2: length(x_noise)
        y(i) = x_noise(i) + b1*x_noise(i-1) + b2* conj(x_noise(i-1)); 
    end
    
    %% Apply complex LMS
    [e_clms,h_clms]=CLMS(M,y,x_noise,mu);
    e_clms_avg = e_clms_avg + 10*log10(abs(e_clms).^2);


    [e_aclms,h_aclms,g_aclms]=ACLMS(M,y,x_noise,mu);
    e_aclms_avg = e_aclms_avg +10*log10(abs(e_aclms).^2);
end
e_aclms_avg_n = e_aclms_avg./Max;
e_clms_avg_n = e_clms_avg./Max;

%%
figure()
plot(1:L-1,e_clms_avg_n)
hold on;
plot(1:L-1,e_aclms_avg_n);
grid on;
xlabel("Sample [n]",'fontsize',12);ylabel("$10\log_{10}(|e(n)|^{2})$ [dB]",'fontsize',12)
legend("CLMS","ACLMS",'fontsize',12);
title(['Learning Curve $\mu$=' num2str(mu)],'fontsize',12)

%%
c_Y = y'*y/length(y);
p_Y = y.'*y/length(y);
n_Y = abs(p_Y) / c_Y;

figure()
scatter(real(y),imag(y))
xlabel("Real",'FontSize',12);
ylabel("imagnary",'FontSize',12);
title(['Scatter plot of WLMA(1) $\eta$=' num2str(n_Y)],'FontSize',12);
grid on;xlim([-13,13]);



A = (randn(L,1) + 1i* randn(L,1))/sqrt(2);
c_AWGN = A'*A/length(A);
p_AWGN = A.'*A/length(A);
n_awgn = abs(p_AWGN) / c_AWGN;
% circular distrubution
figure()
scatter(real(A),imag(A));
xlabel("Real",'FontSize',12);ylabel("Imagnary",'FontSize',12);
title(['Circular White Gaussian Noise $\eta$=' num2str(n_awgn)],'FontSize',12)