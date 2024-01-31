%% example_OFDM_BPSK.m
%   Script showing equivalence of computing the OFDM envelope using the IFFT.
%
%   Cory J. Prust, Ph.D.
%   Last Modified:  8/24/2018

clear all
close all

%% Simulation parameters
N = 4;          % number of subcarriers
Ts = 1/1000;    % bit period of serial data stream
T = N*Ts;       % symbol period of OFDM data
n = 0:(N-1);
f = n/T;        % vector of subcarrier frequencies
A = 1;          % subcarrier amplitude

%% Generate N BPSK data symbols
data = 2*randi([0 1],N,1)-1;

%% Compute complex envelope using Equation 1
g = zeros(N,1);
for ii=1:N
    g = g + A*data(ii)*exp(j*2*pi*f(ii)*n*Ts).';
end

%% Compare g with IFFT - print the two vectors to MATLAB prompt
g
ifft(data)*N    % undo scale by N factor
