clc;
clear all;
close all;
format shorteng;

% SampRate = 44100;
SampRate = 36000;

FilePointer = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\chirp.wav';

[y, SampRate] = audioread(FilePointer);
sound(y, SampRate);

Time = 5;
Length = Time * SampRate;
x = linspace(0, Time, Length);
FreqAxis = linspace(-SampRate/2, SampRate/2, Length);

z = fftshift(abs(fft(y, Length)));

subplot(2,1,1);
plot(x, y);

subplot(2,1,2);
plot(FreqAxis, z);




