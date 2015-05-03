clc;
clear all;
close all;
format shorteng;

%different frequencies of sinusoids
freq1 = 60;
freq2 = 500;
freq3 = 100;

%total time duration
time = 1;

%amount of possible waves to add together
NumWaves = 3;


SamplesPerTime = 36000;             %sample rate
samples = SamplesPerTime * time;    %total samples over duration of signal
Waves = zeros(NumWaves, samples);   %Generate matrix to add sinusoids

x = linspace(0, time, samples);     %time axis
y = zeros(1, samples);              %final signal vector
FreqAxis = linspace(-SamplesPerTime/2, SamplesPerTime/2, samples);  %frequency axis

Waves(1,:) = cos(2 * pi * freq1 * x(1:samples));    %first sinusoid
Waves(2,:) = cos(2 * pi * freq2 * x(1:samples));    %second sinusoid
Waves(3,:) = cos(2 * pi * freq3 * x(1:samples));    %third sinusoid

%add the different sinusoids into one signal
for p = 1:NumWaves
    y(1,:) = y(1,:) + Waves(p, :);
end

%add gaussian white noise
% y(1,:) = awgn(y, -10);

subplot(2, 1, 1); 
plot(x, y);         %plot the signal in the time domain

%find the fft with signal length "samples"
%find the magnitude of the fft
%shift the 0 frequency to the center of the spectrum
z = fftshift(abs(fft(y, samples)));     

subplot(2, 1, 2);

%plot the fourier magnitude spectrum
stem(FreqAxis, z);













