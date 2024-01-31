%% generateComplexEnvelope_APT.m
%   APT sent at 4160 pixels per second
%   Pixels are 8-bit grayscale
%   Pixel information amplitude modulates 2400Hz subcarrier, which is then
%     used to frequency modulate the RF carrier
%   Frequency deviation is 17kHz
%   Image data bandlimited to allow square-law AM demod in receiver

%   Cory J. Prust, Ph.D.
%   Last Modified:  7/29/2018

close all
clear all

%% Create synthetic "APT" image
% load image file
image = imread('wide_med_viets-field-at-dusk.jpg');
image = rgb2gray(image);
image = image(1:550,:);

% add left-hand "telemetry" border; mimic APT
band255 = repmat([255 255 255 255],550,1);
band0 = repmat([0 0 0 0],550,1);
cal = round(linspace(0,255,55))';
calBand = repmat(cal,10,32);

aptImage = [band0 band255 band0 band255 band0 band255 band0 calBand image];

figure
imshow(aptImage)

%% Reshape image to time series
fs_pixels = 4160;
[rows cols] = size(aptImage);
aptData = reshape(aptImage',1,rows*cols);
fprintf('APT Image: %d rows, %d columns\n',rows,cols);
fprintf('Transmission time at %d pixels per second: %d seconds\n', fs_pixels, rows*cols/fs_pixels);

%% threshold data to [0,1] range
aptData = mat2gray(aptData,[0 255]);

%% Filter to allow simple AM square-law receiver
% Need to limit bandwidth B < 1200 Hz (i.e., f_c > 2B for square law demod)
h = fir1(120,1000/(4160/2));  % LFP at 1000Hz
freqz(h,1,1e5,4160);
aptData = filtfilt(h,1,abs(aptData));

%% check image
figure
imshow(reshape(aptData',cols,rows)')

%% Upsample
aptData = resample(double(aptData),240e3,fs_pixels);
fs = 240e3;
N = length(aptData);
t = 0:1/fs:(N-1)/fs;

%% Limit values to [0 1] range.
aptData(aptData>1)=1;
aptData(aptData<0)=0;
figure
plot(aptData)

%% AM Modulate on 2400Hz subcarrier
aptData_AM = aptData .* cos(2*pi*2400*t);

%% FM Modulate
mod = comm.FMModulator('SampleRate',fs,'FrequencyDeviation',17e3);
aptData_FM = step(mod,aptData_AM');

% normalize complex envelope
aptData_FM = aptData_FM * 0.8;  % ensure magnitude < 1 to prevent saturation in USRP

%% Plots
f = (-fs/2):(fs/N):(fs/2 - fs/N);
figure
plot(f,20*log10(abs(fftshift(fft(aptData)))));
figure
plot(f,20*log10(abs(fftshift(fft(aptData_AM)))));
figure
plot(f,20*log10(abs(fftshift(fft(aptData_FM)))));

save 'syntheticAPTData.mat' fs aptData_FM cols rows
