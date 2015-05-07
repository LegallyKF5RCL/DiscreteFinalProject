clc;
clear all;
close all;
format shorteng;

%SampRate = 44100;
SampRate = 36000;

TimeLength = 5;
Samples = TimeLength * SampRate;

Time = linspace(0, TimeLength, Samples);

y = chirp(Time, 200, TimeLength/2, 9000);


FilePointer = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Chirp.wav';
audiowrite(FilePointer, y, SampRate);

[y, SampRate] = audioread(FilePointer);
sound(y, SampRate);


plot(Time, y);
