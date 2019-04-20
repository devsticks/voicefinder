[y1,fs1] = audioread('sf1_cln.wav');
%sound(y,Fs);
%specgram(y1,1024,fs1);

data_fft1 = fft(y1);
dataShift1 = fftshift(data_fft1);
plot(abs(dataShift1(:,1)));

[y2,Fs2] = audioread('sm3_cln.wav');
%sound(y2,Fs2);
%figure; specgram(y2,1024,Fs2);
%hold on;
data_fft2 = fft(y2);
dataShift2 = fftshift(data_fft2);
figure; plot(abs(dataShift2(:,1)));