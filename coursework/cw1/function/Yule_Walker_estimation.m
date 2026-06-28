% Claudio Dong Imperial College London 2/5/2024
%
% This function is used to produce the unbiased autocorrelation function
% coefficient
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Input
% - p_order = the model order p
% - ACF_biased = biased autocorrelation function coefficient
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% - Output
% - ACF_p_coeff = estimated ACF p coefficient
% - sigma_estimate = estimated noise power
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function [ACF_p_coeff,sigma_estimate]= Yule_Walker_estimation(p_order,ACF_biased)
    staring = (length(ACF_biased)+1)/2;
    Matrix = zeros(p_order+1);
    for i = 0:p_order
        % shift the ACF to left with circular shift
        shift_coe = circshift(ACF_biased,i);
        % forming the matrix ,should have size of p+1 x p+1
        % only take the from [original to original+p], since the  
        Matrix(:,i+1) = shift_coe(staring:staring+p_order);
    end
    % RHS vector   
    sigma_vector = zeros(length(Matrix),1);
    sigma_vector(1) = 1;    
    % compute the a_vector
    eea = inv(Matrix)*sigma_vector; % compute the inverse matrix result with [1,0,...0]
    sigma_estimate = 1/eea(1); % find the sigma value
    a_vector = eea(2:end)*sigma_estimate; % compute the new ACF coefficient
    ACF_p_coeff =  - a_vector.';
    % compute the Yule-Walker estimation, the coefficient should change to
    % -coefficient, because it compute the 1+sum()
end
