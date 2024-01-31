%% papr_OFDM_BPSK.m
%   Script that computes PAPR for BPSK modulated OFDM (802.11a) 
%
%   Cory J. Prust, Ph.D.
%   Last Modified:  8/25/2018

clear all
close all

% simulation parameters
Nsym = 1e4;                             % number of OFDM symbols

% parameters for the OFDM modulator (similar to 802.11a)
nfft = 64;                  % fft size
cpLen = 16;                 % OFDM cyclic prefix length
nullIdx = [1:6 33 60:64]';  % guard bands and 0Hz null

PAPRdB = zeros(Nsym,1);
for ii = 1:Nsym
    % apply modulation
    binaryData = randi([0 1],52,1);
    bpskData = pskmod(binaryData,2);
    ofdmData = ofdmmod(bpskData,nfft,cpLen,nullIdx);
    
    % compute PAPR
    peakValue = max(ofdmData.*conj(ofdmData));
    meanSquareValue = mean(ofdmData.*conj(ofdmData));
    PAPRdB(ii) = 10*log10(peakValue/meanSquareValue);
end

% histogram PAPR values
histogram(PAPRdB,[0:0.2:15])
title('Histogram plot of PAPR values for 802.11a type OFDM waveform (BPSK)');
xlabel('PAPR (dB)')
ylabel('counts')


