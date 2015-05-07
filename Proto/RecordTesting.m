clc;
clear all;
close all;
format shorteng;

LiveInput = audiorecorder(36000, 16, 1);

LiveInput.StartFcn = 'disp(''BEGIN'')';
LiveInput.StopFcn = 'disp(''STOP'')';

record(LiveInput, 10);
input('Press a key to continue...');
y = getaudiodata(LiveInput);
