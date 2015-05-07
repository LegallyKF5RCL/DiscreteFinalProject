clc;
clear all;
close all;
format shorteng;

FPChirpIdeal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Chirp.wav';
FPChirpRec = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Bridge\BridgeChirp.wav';
% FPNoise = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Bridge\NoiseAt44k_Bridge.wav';
FPSignal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\Classroom\ClassroomRegan2.wav';
FPOriginal = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\Audio\AudioTracks\The Best of Ronald Reagan.wav';

[ChirpIdeal44, RecordRate] = audioread(FPChirpIdeal);
[ChirpRec44, RecordRate] = audioread(FPChirpRec);
% [Noise44, RecordRate] = audioread(FPNoise);
[Signal44, RecordRate] = audioread(FPSignal);
[Original44, RecordRate] = audioread(FPOriginal);

Fs = 36000;         %Sample Frequency

[N, D] = rat(Fs / RecordRate);  %Find the ratio of the sample frequency to record sample rate

%resample everything to 36k
ChirpIdeal = resample(ChirpIdeal44, N, D);      %generated chirp 
ChirpRec = resample(ChirpRec44, N, D);          %chirp recorded through the channel
% Noise = resample(Noise44, N, D);                %noise recording
Signal = resample(Signal44, N, D);              %noisy signal to be filtered
Original = resample(Original44, N, D);          %Original signal with minimal noise

%block of code below is for live recording
Signal = audiorecorder(36000, 16, 1);           %record at 36ksam/s, 16bit, mono
Signal.StartFcn = 'disp(''BEGIN'')';            %when recording starts show message
Signal.StopFcn = 'disp(''STOP'')';              %when recording ends show message
record(Signal, 10);                             %record to Signal for an amount of time
input('Press enter AFTER ''STOP''');     %wait for user input after done recording
Signal = getaudiodata(Signal);                  %convert to useable format

[Length, Channel] = size(Signal);               %determine how many samples in the signal

Time = Length / Fs;             %determine time based on sample frequency
f = linspace(-Fs/2, Fs/2, Length);  %create frequency axis
t = linspace(0,Time,Length);        %time axis
 
[Remain, other] = size(ChirpRec);
Count = 0;

while Remain > Length           %figure out how many whole segments the chrip 
    Count = Count + 1;          %signal can be divided into
    Remain = Remain - Length;   
end

% while NoiseRemain > Length           %figure out how many whole segments the chrip 
%     Count2 = Count2 + 1;          %signal can be divided into
%     NoiseRemain = NoiseRemain - Length;   
% end

% NoiseMatrix = zeros(Count2, Length);
% NoiseVector = zeros(1, Length);
IChirpBand = zeros(Length, 1);          %make zero vectors
ChirpMatrix = zeros(Count, Length);
ChirpVector = zeros(1, Length);
Bandpass = zeros(Length, 1);
ChirpBand = zeros(Length, 1);
Equalize = zeros(Length, 1);
Final = zeros(Length, 1);

% for jj = 1:Count2
%     for kk = 1:Length
%         NoiseMatrix(jj, kk) = Noise(((jj - 1)*Length + kk),1);
%     end
% end
% 
% for jj = 1:Count2
%     NoiseVector(1,:) = NoiseVector(1,:) + NoiseMatrix(jj,:);
% end
% 
% NoiseVector(1,:) = NoiseVector(1,:) / Count2;       %average
% NoiseSpec = fft(NoiseVector, Length);
% 
% figure;
% plot(f, NoiseSpec);
% title('Nosie Spectrum');

    OrigSpec = fft(Original, Length);   %spectrum of Original signal

%     figure;
%     subplot(2,1,1);
%     plot(f, fftshift(abs(OrigSpec)));
%     title('Original Signal Magnitude');
%     subplot(2,1,2);
%     plot(f, fftshift(angle(OrigSpec)));
%     title('Original Signal Phase');

% Average chirp recordings
    for jj = 1:Count
        for kk = 1:Length
            ChirpMatrix(jj, kk) = ChirpRec(((jj - 1)*Length + kk),1);
        end
    end

    for jj = 1:Count
        ChirpVector(1,:) = ChirpVector(1,:) + ChirpMatrix(jj,:);
    end

    ChirpVector(1,:) = ChirpVector(1,:) / Count;       %average

    ChirpSpecHold = fft(ChirpVector, Length);
    ChirpSpec = ChirpSpecHold.';
    ChirpMag = fftshift(abs(ChirpSpec));
    ChirpPha = fftshift(angle(ChirpSpec));
    
    for jj = 1:Length
        %manually band pass the desired band
        %the frequencies are scaled relative to the n-point fft
        if ((jj >= 200*Time) && (jj <= 14000*Time))
            ChirpBand(jj, 1) = ChirpSpec(jj, 1);
        end
        if ((jj >= Length - 14000*Time) && (jj <= Length - 200*Time))
            ChirpBand(jj, 1) = ChirpSpec(jj, 1);
        end
    end
    
%     figure;
%     subplot(2,1,1);
%     plot(f, fftshift(abs(ChirpBand)));
%     title('Bridge Recorded Chirp Magnitude');
%     subplot(2,1,2);
%     plot(f, fftshift(angle(ChirpBand)));
%     title('Classroom Recorded Chirp Phase');
    
    SignalSpec = fft(Signal, Length);
    
%     figure;
%     subplot(2,1,1);
%     plot(f, fftshift(abs(SignalSpec))); %plot signal Magnitude
%     title('Bridge Noisy Signal Magnitude');
%     subplot(2,1,2);
%     plot(f, fftshift(angle(SignalSpec))); %plot signal Magnitude
%     title('Noisy Signal Phase');
    
    IChirpSpec = fft(ChirpIdeal, Length);

        for jj = 1:Length
            %manually band pass the desired band
            %the frequencies are scaled relative to the n-point fft
            if ((jj >= 200*Time) && (jj <= 14000*Time))
                IChirpBand(jj, 1) = IChirpSpec(jj, 1);
            end
            if ((jj >= Length - 14000*Time) && (jj <= Length - 200*Time))
                IChirpBand(jj, 1) = IChirpSpec(jj, 1);
            end
        end
    
%     figure;
%     subplot(2,1,1);
%     plot(f, fftshift(abs(IChirpBand)));
%     title('Ideal Chirp Magnitude');
%     subplot(2,1,2);
%     plot(f, fftshift(angle(IChirpBand)));
%     title('Ideal Chirp Phase');
    
for jj = 1:Length
    %manually band pass the voice band
    %the frequencies are scaled relative to the n-point fft
    if ((jj >= 300*Time) && (jj <= 3300*Time))
        Bandpass(jj, 1) = SignalSpec(jj, 1);
    end
    if ((jj >= Length - 3300*Time) && (jj <= Length - 300*Time))
        Bandpass(jj, 1) = SignalSpec(jj, 1);
    end
    %Below is extra bandreject filter
%     if ((jj >= 1000*Time) && (jj <= 3300*Time))
%         Bandpass(jj, 1) = 0;
%     end
%     if ((jj >= Length - 3300*Time) && (jj <= Length - 1000*Time))
%         Bandpass(jj, 1) = 0;
%     end
end

% figure
% subplot(2,1,1);
% plot(f, fftshift(abs(Bandpass)));   %plot Filtered Magnitudes
% title('Classroom Signal Bandpassed Magnitude');
% subplot(2,1,2);
% plot(f, fftshift(angle(Bandpass)));   %plot Filtered Magnitudes
% title('Signal Bandpassed Phase');

%Xiangs code will go here



for jj = 1:Length
    if ChirpBand(jj,1) <= .01;
        ChirpBand(jj, 1) = .01;
    end
end

for jj = 1:Length
    Final(jj, 1) = Bandpass(jj, 1) / ChirpBand(jj, 1);
    Final(jj, 1) = Final(jj, 1) / 30;
end

% figure;
% subplot(2,1,1);
% plot(f, fftshift(abs(Final)));
% title('Signal Magnitude Spectrum equalized');
% subplot(2,1,2);
% plot(f, fftshift(angle(Final)));
% title('Signal Phase Spectrum equalized');

z = ifft(SignalSpec);               %inverse fft of signal spectrum for reference
y = ifft(Bandpass, 'symmetric');    %inverse fft of filtered signal
x = ifft(Final, 'symmetric');

% sound(Original, Fs);
sound(z, Fs);       %Play noisy signal
% sound(y, Fs);       %Play filtered signal
% sound(x, Fs);       %Play filtered signal

% Remove noise below the mean value of the siganl fft.
fscnfft=fft(y,Length);
fft_values=fscnfft;
mean_value = mean(abs(fscnfft));
threshold = 1*mean_value; % Fine-tune this
fft_values(abs(fft_values) < threshold)=0*fft_values(abs(fft_values) < threshold)/1000 ;
fft_values(abs(fft_values) > threshold)=fft_values(abs(fft_values) > threshold)*1;
filtered_samples = ifft(fft_values,Length);

% [fscn, fscnfft, y20] = allSpec( y,fs0 );
% title('Recovery AfterBandpass ');
% 
% [fscn, fscnfft, y20] = allSpec( y,fs0 );
% title('Recovery AfterBandpass ');
% [fscn, fscnfft, y20] = allSpec(filtered_samples,fs0 );
% title('Recovery After Filter ');
% 
% sound(z, Fs);       %Play noisy signal
sound(y, Fs);  %Play bandpass signal
% input('Press enter to continue...')
% sound(filtered_samples, Fs);       %Play filtered signal
% sound(x, Fs);       %Play filtered signal


% FilePointer = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\ClassroomNoisySignal.wav';
% audiowrite(FilePointer, z, Fs);
% FilePointer = 'C:\Users\KF5RCL\Desktop\MyStuff\Classes\Discrete\DiscreteFinalProject\ClassroomFilteredSignal.wav';
% audiowrite(FilePointer, y, Fs);

disp('DONE');       










