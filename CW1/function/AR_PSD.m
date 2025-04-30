% Haozheng Dong 01884083 Imperial COllege London 2/5/2024
% Autoregression Power Spectrum Estimation
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Input:
%
% - coefficient: ACF autocorrelation function
% - fftn: FFT sample number
% - sigma: noise power
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Output:
% - PSD  = the estimated power spectrum (not in dB)
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function PSD = AR_PSD(coefficient,fftn,sigma)
    N_c = length(coefficient);
    % Gnenerate the AR power
    w =  0:2*pi/(fftn-1):2*pi;
    e = exp(-1i.*w);
    k = 1:N_c;
    PSD = zeros(1,fftn);
    for i = 1:fftn
        PSD(i) = sigma / abs(1 - sum(coefficient.*e(i).^k)).^2;
    end
end