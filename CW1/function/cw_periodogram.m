% Haozheng Dong 01884083 Imperial College London 2/5/2024
%
% This function is used to produce the unbiased autocorrelation function
% coefficient
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Input
% - x = input signal
% - fftn = FFT sample numer
% - dB = if the dB is type in, then the output PSD is in dB scale
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Output
% - PSD = Estimated Power spectrum desinty
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function PSD = cw_periodogram(x,fftn,dB)
  N = length(x);       % Number of samples have in signal x
  PSD = abs(fft(x,fftn)).^2 ./N; % perfrom fft to thx signal
  PSD = PSD(1:fftn/2+1);
  if strcmp(dB,'dB')
    PSD = 10*log10(PSD);
  end

end