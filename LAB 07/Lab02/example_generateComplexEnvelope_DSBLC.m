%% example_generateComplexEnvelope_DSBLC.m
%   Example script showing how to generate a complex envelope 
%   for broadcasting with Ettus B200 USRP.
%   This version generates a DSB-LC waveform with a voice message signal.
%
%   Cory J. Prust, Ph.D.
%   Last Modified:  7/2/2018

%%  USRP Configuration
%   The script generates the complex envelope sampled at 240kHz
%   So, the B200 must be configured for MasterClockRate/Interpolation = 240000.
%    e.g., MasterClockRate = 9600000 and Interpolation = 40 
clear all
close all

%% load .wav file
[m, fs_audio] = audioread('myAudioFile.wav');

%% trim length and extract left/right audio as needed
% ADD CODE HERE

%% design and apply an FIR lowpass filter to limit the message bandwidth
f_cutoff = ?                            % cutoff frequency in Hz
order = 50;                             % filter order (higher order gives sharper cutoff)
h = fir1(order,f_cutoff/(fs_audio/2));  % see "help fir1"
freqz(h,1,1e5,fs_audio);                % view your filter design
m = filter(h,1,m);                      % apply filter to the message

% resample to USRP sample rate
fs = 240000;                    %USRP baseband sample rate
m = resample(m',fs,fs_audio);   %note transpose here to convert to row vector

% generate DSB-LC
mu = 1.2;   % modulation index
a = max(m);
A = mu*a;

% generate complex envelope
z = (A + m);

% normalize complex envelope
z = z/max(abs(z)) * 0.8;  % ensure magnitude < 1 to prevent saturation in USRP

% time-domain plots
N = length(m);
t = 0:(1/fs):(N-1)*(1/fs);
figure
plot(t,real(z))

% frequency-domain plot
f = -fs/2:(fs/N):(fs/2 - fs/N);
figure
plot(f,20*log10(abs(fftshift(fft(z)))))