% Claudio Dong Imperial College London 2/5/2024
%
% This function is used to produce average periogogram method as (Bartlett method)
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Input
% - x = input signal
% - fftn = FFT sample numer
% - window_size = the length of window in time (window length /T)
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Output
% - PSD = Estimated Power spectrum desinty
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function PSD = cw_average_periodogram(x,fftn,window_size)
  N = length(x);                         % Number of samples have in signal x
  Window_number = ceil(N / window_size); % window number
  PSD = zeros(fftn/2+1,1);               % the length of PSD

  % Loop
  for i = 1:Window_number 
      starting = (i-1)*window_size +1; % start 
      ending = i*window_size; % end
      if ending > N % if larger than N, then let ending = N to make sure collect all data
          ending = N;
      end
      x_sub = x(starting:ending);
      PSD = PSD + cw_periodogram(x_sub,fftn,''); % perfrom traditonal periodgram but not in dB
  end
  PSD = PSD ./ Window_number; % average the PSD based on the window length
end