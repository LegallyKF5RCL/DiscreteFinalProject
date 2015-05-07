clc;
clear all;
close all;
format shorteng;

FPChirpIdeal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Chirp.wav';
FPChirpRec = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Bridge\BridgeChirp.wav';
FPNoise = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Classroom\NoiseAt44k_Classroom.wav';
FPSignal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Bridge\BridgeRegan.wav';

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
NoiseMatrix = zeros(22, Length);
NoiseVector = zeros(1, Length);
Time = Length / Fs;             %determine time based on sample frequency
% f = linspace(-Fs/2, Fs/2, Length);  %create frequency axis
f = linspace(-Fs/2, Fs/2, Length);


for jj = 1:3        %make the Chirp sequence finitely periodic
   ChirpIdeal  = cat(1, ChirpIdeal, ChirpIdeal);
end

for jj = 1:3        %make the Chirp sequence finitely periodic
   ChirpRec  = cat(1, ChirpRec, ChirpRec);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find Fourier Transform of Ideal Chirp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IChirpSpec = fft(ChirpIdeal, Length);
IChirpMag = fftshift(abs(IChirpSpec));
IChirpPha = fftshift(angle(IChirpSpec));


figure; 
stem(f, IChirpMag);
title('Ideal Chirp Magnitude Spectrum');
% subplot(2,1,1);
% stem(f, IChirpMag);
% title('Ideal Chirp Magnitude Spectrum');
% subplot(2,1,2);
% plot(f, IChirpPha);
% title('Ideal Chirp PhaseSpectrum');


%%%

RChirpSpec = fft(ChirpRec, Length);
RChirpMag = fftshift(abs(RChirpSpec));
RChirpPha = fftshift(angle(RChirpSpec));

figure;
stem(f, RChirpMag);
title('Recorded Chirp Magnitude Spectrum');
% subplot(2,1,1);
% stem(f, RChirpMag);
% title('Recorded Chirp Magnitude Spectrum');
% subplot(2,1,2);
% plot(f, RChirpPha);
% title('Recorded Chirp Phase Spectrum');

%%%

%Noise sample length / variable Length = 22.336
%truncate
for jj = 1:22
    for kk = 1:Length
        NoiseMatrix(jj, kk) = Noise(((jj - 1)*Length + kk),1);
    end
end

for jj = 1:22
    NoiseVector(1,:) = NoiseVector(1,:) + NoiseMatrix(jj,:);
end

NoiseVector(1,:) = NoiseVector(1,:) / 22;       %average

NoiseSpec = fft(NoiseVector, Length);
NoiseMag = fftshift(abs(NoiseSpec));
NoisePha = fftshift(angle(NoiseSpec));

NoiseSpec = NoiseSpec.';

figure;
plot(f, NoiseMag);
title('Classroom Noise Magnitude Spectrum');
% subplot(2,1,1);
% stem(f, NoiseMag);
% title('Noise Magnitude Spectrum');
% subplot(2,1,2);
% plot(f, NoisePha);
% title('Noise Phase Spectrum');

%%%

SignalSpec = fft(Signal, Length);
SignalMag = fftshift(abs(SignalSpec));
SignalPha = fftshift(angle(SignalSpec));

figure;
stem(f, SignalMag);
title('Signal Magnitude Spectrum');
% subplot(2,1,1);
% stem(f, SignalMag);
% title('Signal Magnitude Spectrum');
% subplot(2,1,2);
% plot(f, SignalPha);
% title('Signal Phase Spectrum');

NoiseCancel = (SignalSpec - NoiseSpec);

% Equalize = NoiseCancel/LRChirpSpec;
Equalized = zeros(Length, 1);
for jj = 1:Length
    Equalized(jj,1) = NoiseCancel(jj,1) ./ abs(RChirpSpec(jj,1));
end

% figure;
% QWER = fftshift(abs(fft(Equalized, Length)));
% stem(f, QWER);

Recover = ifft(NoiseCancel);
% Recover = ifft(Equalized);

% sound(Signal, Fs);
% sound(Recover, Fs);

FilePointer = 'FilteredSignal.wav';
audiowrite(FilePointer, Recover, Fs);

disp('DONE');















