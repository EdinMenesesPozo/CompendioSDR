%% example_correlation.m
%   Example script that computes the autocorrelation function of a
%   PN sequence.  The script also demonstrates using the MATLAB "xcorr" 
%   function to correlate a received signal with a PN sequence.
%
%   Cory J. Prust, Ph.D.
%   Last Modified:  8/3/2018

close all
clear all

%% Specify PN code
code = [-1 1 -1 1 1 1 -1 1 1 -1 -1 -1 1 1 1 1]';
M = length(code);

%% Compute Autocorrelation Function
% R[k] = 1/M sum_{n=1}^{M} c[n] c[n-k]
% Note: "circshift" is used because the sequence is assumed periodic
R = zeros(M,1)
k = 0:1:(M-1);
for ii=1:length(k)
    R(ii) = 1/M * (code' * circshift(code,k(ii))); % circshift 
end
stem(k,R)

%% Simulate received DSSS data and use "xcorr" to correlate it with PN code
% Assume spreading factor of M
m = [1 1 -1 1]';
g = [m(1)*code; m(2)*code; m(3)*code; m(4)*code]; % or, use "g = kron(m,code);"

[r,lag] = xcorr(g,code);
figure
stem(lag,r)



