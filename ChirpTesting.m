clc;
clear all;
close all;
format shorteng;

SampRate = 44100;
% SampRate = 36000;

FilePointer = 'C:\Users\KF5RCL\Documents\MATLAB\chirp.wav';

[y, SampRate] = audioread(FilePointer);
% sound(y, SampRate);

Time = 2;
Length = 2 * SampRate;
x = linspace(0, Time, Length);
FreqAxis = linspace(-SampRate/2, SampRate/2, Length);

z = fftshift(abs(fft(y, Length)));

subplot(2,1,1);
plot(x, y);

subplot(2,1,2);
stem(FreqAxis, z);




