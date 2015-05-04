clc;
clear all;
close all;
format shorteng;

%SampRate = 44100;
SampRate = 36000;

TimeLength = 2;
Samples = TimeLength * SampRate;

Time = linspace(0, TimeLength, Samples);

y = chirp(Time, 0, TimeLength/2, 10000);


FilePointer = 'Chirp.wav';
audiowrite(FilePointer, y, SampRate);

[y, SampRate] = audioread(FilePointer);
sound(y, SampRate);


plot(Time, y);
