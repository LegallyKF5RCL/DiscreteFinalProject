clc;
clear all;
close all;
format shorteng;

FPChirpIdeal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Chirp.wav';
FPChirpRec = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Classroom\ClassroomChirp.wav';
FPNoise = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Bridge\NoiseAt44k_Bridge.wav';
FPSignal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Classroom\ClassroomRegan2.wav';

[ChirpIdeal44, RecordRate] = audioread(FPChirpIdeal);
[ChirpRec44, RecordRate] = audioread(FPChirpRec);
[Noise44, RecordRate] = audioread(FPNoise);
[Signal44, RecordRate] = audioread(FPSignal);

% sound(Signal44, 44100);

Fs = 36000;         %Sample Frequency

[N, D] = rat(Fs / RecordRate);  %Find the ratio of the sample frequency to record sample rate

ChirpIdeal = resample(ChirpIdeal44, N, D);
ChirpRec = resample(ChirpRec44, N, D);
Noise = resample(Noise44, N, D);
Signal = resample(Signal44, N, D);

%for matrix math all vectors must be same length
%choosing the signal for the standard length
[Length, Channel] = size(Signal);
Time = Length / Fs;             %determine time based on sample frequency


f = linspace(-Fs/2, Fs/2, Fs);  %create frequency axis

%%%%%
%fft testing
%%%%%
% t = linspace(0,Time,Length);

% x = cos(2*pi*500*t(1,:));
% X = fftshift(abs(fft(x, Fs)));
% stem(f, X);
%%%%%
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find Fourier Transform of Ideal Chirp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing a short segment of the chirp sound
% Shortc(1:1000,1) = ChirpIdeal(1:1000,1);
% 
% ShortcSpec = fft(Shortc, Fs);
% ShortcMag = fftshift(abs(ShortcSpec));
% ShortcPha = fftshift(abs(ShortcSpec));
% 
% figure;
% subplot(2,1,1);
% stem(f, ShortcMag);
% subplot(2,1,2);
% plot(f, ShortcPha);

IChirpSpec = fft(ChirpIdeal, Fs);
IChirpMag = fftshift(abs(IChirpSpec));
IChirpPha = fftshift(angle(IChirpSpec));

% figure;
% subplot(2,1,1);
% stem(f, IChirpMag);
% subplot(2,1,2);
% plot(f, IChirpPha);

RChirpSpec = fft(ChirpRec, Fs);
RChirpMag = fftshift(abs(RChirpSpec));
RChirpPha = fftshift(angle(RChirpSpec));

% figure;
% subplot(2,1,1);
% stem(f, RChirpMag);
% subplot(2,1,2);
% plot(f, RChirpPha);

%Does spec of all noise resemble a smaller portion?
% ShortNoise(1:Fs,1) = Noise(1:Fs,1);   %grab 1s of noise
% 
% ShortNoiseSpec = fft(ShortNoise, Fs);
% ShortNoiseMag = fftshift(abs(ShortNoiseSpec));
% ShortNoisePha = fftshift(abs(ShortNoiseSpec));
% 
% figure;
% subplot(2,1,1);
% stem(f, ShortNoiseMag);
% subplot(2,1,2);
% plot(f, ShortNoisePha);

NoiseSpec = fft(Noise, Fs);
NoiseMag = fftshift(abs(NoiseSpec));
NoisePha = fftshift(angle(NoiseSpec));

figure;
subplot(2,1,1);
stem(f, NoiseMag);
subplot(2,1,2);
plot(f, NoisePha);

SignalSpec = fft(Signal, Fs);
SignalMag = fftshift(abs(SignalSpec));
SignalPha = fftshift(angle(SignalSpec));

% figure;
% subplot(2,1,1);
% stem(f, SignalMag);
% subplot(2,1,2);
% plot(f, SignalPha);

%Retake fft with respect to the length of the signal
f = linspace(-Fs/2, Fs/2, Length);  %create frequency axis


LIChirpSpec = fft(ChirpIdeal, Length);
LRChirpSpec = fft(ChirpRec, Length);
LNoiseSpec = fft(Noise, Length);
LSignalSpec = fft(Signal, Length);

LChirpMag = fftshift(abs(LRChirpSpec));
figure;
stem(f, LChirpMag);
% asdf = fftshift(abs(fft(LNoiseSpec)));
% stem(f, asdf)

NoiseCancel = (LSignalSpec - LNoiseSpec);

% Equalize = NoiseCancel/LRChirpSpec;
Equalized = ones(Length, 1);
for jj = 1:Length
    Equalized(jj,1) = NoiseCancel(jj,1) / abs(LRChirpSpec(jj,1));
end

Recover = ifft(Equalized);

% sound(Signal, Fs);
sound(Recover, Fs);

disp('DONE');















