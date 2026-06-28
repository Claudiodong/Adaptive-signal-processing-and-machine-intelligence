% Claudio Dong Imperial College London 2/5/2024
%
% This function is used to produce the unbiased autocorrelation function
% coefficient
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Input
% - ACF = autocorrelation function coefficient
% - fftn = FFT sample numer
% - k = Autocorrelation lags
% - dB = if dB is exist, then the output is in dB scale
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Output
% - PSD = Estimated Power spectrum desinty
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function PSD = correlogram(ACF,fftn,k,dB)
    PSD = zeros(1,fftn);
    w = 0:(2*pi)/(fftn-1):2*pi;
    e = exp(1i*w);
    for i = 1:fftn
        PSD(i) = sum(ACF.*e(i).^k);
    end
    PSD = real(PSD+1);

    if strcmp(dB,'dB')
     PSD = 10*log10(PSD);
    end
end