clc;
clear all;
close all;
format shorteng;

% RecordRate = 44100;

%Pointer to recording at 44.1kHz
FilePointerNoise44 = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\Project\Audio\NoiseAt44k_Bridge.wav';
FilePointerSpeech44 = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\Project\Audio\PatriceOneal.wav';
%Read in the noise recording
[Noise44, RecordRate] = audioread(FilePointerNoise44);
[Signal44, RecordRate] = audioread(FilePointerSpeech44);

% sound(Signal44, RecordRate);

Fs = 36000;
Time = 10;              %signal time lengths of 10 seconds
Length = Time * Fs;     %amount of samples per 10 seconds
f = linspace(-Fs/2, Fs/2, Length);


%Approximate the integer ratio of the 2 frequencies
[N, D] = rat(Fs / RecordRate);

NoiseHold = resample(Noise44, N, D);
Noise = NoiseHold.';

SignalMono(:,1) = Signal44(:, 1);              %pick a channel
% input('');
SignalHold = resample(SignalMono, N, D);
Signal = SignalHold.';

% sound(Signal, Fs);

SigSpec = fft(Signal, 419750);
SigMag = fftshift(abs(SigSpec));
SigPha = fftshift(angle(SigSpec));

f = linspace(-Fs/2, Fs/2, 419750);

subplot(2,1,1);
stem(f, SigMag);
subplot(2,1,2);
plot(f, SigPha);

NoiseMatrix = zeros(24, Fs * 10);
SpectrumVector = zeros(1, Fs * 10);

Recover = ifft(SigSpec);

sound(Recover, 36000);

% SignalLength = size(Noise);         %find the length of the signal
% SignalLength = SignalLength(1,2);   %extract useful info
%Noise = 1:1:Length;        %test if loop works

%Truncate the noise signal into 24 samples of 10 seconds
% for kk = 1:24
%     for jj = 1:(Fs * 10)
%         NoiseMatrix(kk, jj) = Noise(1, (kk-1)*Fs + jj);
%     end
% end
% 
% for kk = 1:24
%         SpectrumVector(1,:) = SpectrumVector(1,:) + fftshift(fft(NoiseMatrix(kk,:), Fs * 10));
% end
% 
% SpectrumVector(1,:) = SpectrumVector(1,:) / 24;
% 
% Mag = abs(SpectrumVector);
% Pha = angle(SpectrumVector);
% subplot(2,1,1);
% stem(f, Mag);
% subplot(2,1,2);
% plot(f, Pha);



disp('DONE')










