%% generateComplexEnvelope_ASK_FSK_PSK.m
%   Generates a complex envelope for broadcasting with Ettus B200 USRP.
%   This version generates ASK, FSK, and PSK waveforms with
%   digital modulating signals.
%   The carrier signals are separated by 40kHz.
%
%   Cory J. Prust, Ph.D.
%   Last Modified:  8/16/2018

%%  USRP Configuration
%   The script generates the complex envelope sampled at 240kHz
%   So, the B200 must be configured for MasterClockRate/Interpolation = 240000.
%    e.g., MasterClockRate = 9600000 and Interpolation = 40 
clear all
close all

% sample rate
fs = 240e3;
T = 2; % will generate T second duration waveforms
t = 0:(1/fs):(T-1/fs);
N = length(t);

%% Generate ASK message signal
%  to keep things simple, ensure message is exactly T seconds long
fb_ASK = 1200; %bit rate (bits/sec)
Nb_ASK = fb_ASK * T; %number of bits
m_ASK = randi(2,1,Nb_ASK)-1; %generate bit sequence
m_ASKp = rectpulse(m_ASK,(fs/fb_ASK));

% generate ASK complex envelope
fi_ASK = 90e3;
z_ASK = m_ASKp.*exp(j*2*pi*fi_ASK*t);

%% Generate FSK message signal
%  to keep things simple, ensure message is exactly T seconds long
fb_FSK = 800; %bit rate (bits/sec)
Nb_FSK = fb_FSK * T; %number of bits
m_FSK = 2*randi(2,1,Nb_FSK)-3; %generate bit sequence
m_FSKp = rectpulse(m_FSK,(fs/fb_FSK));

% generate FSK complex envelope
mod = comm.FMModulator('SampleRate',fs,'FrequencyDeviation',3e3);
z_FSK = step(mod,m_FSKp').';
fi_FSK = 50e3;
z_FSK = z_FSK.*exp(j*2*pi*fi_FSK*t);


%% Generate PSK message signal
%  to keep things simple, ensure message is exactly T seconds long
fb_PSK = 600; %bit rate (bits/sec)
Nb_PSK = fb_PSK * T; %number of bits
m_PSK = 2*randi(2,1,Nb_PSK)-3; %generate bit sequence
m_PSKp = rectpulse(m_PSK,(fs/fb_PSK));

% generate PSK complex envelope
fi_PSK = 10e3;
z_PSK = m_PSKp.*exp(j*2*pi*fi_PSK*t);

%% form transmit waveform and normalize complex envelope
z = z_ASK + z_FSK + z_PSK;
z = z/max(abs(z)) * 0.8;  % ensure magnitude < 1 to prevent saturation in USRP

% time-domain plots
figure
hold on
plot(t,real(z))
plot(t,imag(z))
plot(t,abs(z))
plot(t,angle(z))
legend('real','imag','abs','angle')

% frequency-domain plot
f = -fs/2:(fs/N):(fs/2 - fs/N);
figure
plot(f,20*log10(abs(fftshift(fft(z)))));
