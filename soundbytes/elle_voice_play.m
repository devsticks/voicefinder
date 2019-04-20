%[y,Fs] = audioread('mouse.m4a');
%wavFilename = 'mouse.wav';
%audiowrite(wavFilename,y,Fs);


%[y1,fs1] = audioread('Elle_low.wav');
[y1,fs1] = audioread('Elle_low.m4a');
y1 = y1(:,1);
y1 = y1(1:150000);
%sound(y1,fs1);
%specgram(y1,1024,fs1);

data_fft1 = fft(y1);
dataShift1 = fftshift(data_fft1);
plot(abs(dataShift1(:,1)));

%[y2,Fs2] = audioread('Elle_low.wav');
[y2,Fs2] = audioread('Elle_high.m4a');
y2 = y2(:,1);
y2 = y2(1:150000);
%sound(y2,Fs2);
%figure; specgram(y2,1024,Fs2);
hold on;
data_fft2 = fft(y2);
dataShift2 = fftshift(data_fft2);
plot(abs(dataShift2(:,1)));



