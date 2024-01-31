%% papr_OFDM_BPSK.m
%   Script that computes PAPR for BPSK modulated OFDM (802.11a) 
%
%   Cory J. Prust, Ph.D.
%   Last Modified:  8/25/2018

clear all
close all

% simulation parameters
Nsym = 1e4;                             % number of OFDM symbols

% specify OFDM modulator (similar to 802.11a)
ofdmMod = comm.OFDMModulator;
ofdmMod.FFTLength = 64;                 % number of OFDM subcarriers
ofdmMod.NumGuardBandCarriers = [6; 5];  % guard bands
ofdmMod.InsertDCNull = true;            % do not use 0Hz subcarrier
ofdmMod.CyclicPrefixLength = 16;        % OFDM cyclic prefix lengt

% specify BPSK modulator
bpskMod = comm.BPSKModulator;

PAPRdB = zeros(Nsym,1);
for ii = 1:Nsym
    % apply modulation
    binaryData = randi([0 1],52,1);
    bpskData = bpskMod(binaryData);
    ofdmData = ofdmMod(bpskData);
    
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


