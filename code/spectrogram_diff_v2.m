
%get dem tracks
%specify sampling frequency
Fs = 48000;
window_length = 500;%48000*10;
overlap = 10;
fft_freqs = 500; 

filenames = ["Dev", "Elle", "DevElleDiff", "DevElleSame", "silence", "testingVariety"];
filenames1 = "../sound_recs_aligned/mic1_" + filenames + ".wav";
filenames2 = "../sound_recs_aligned/mic2_" + filenames + ".wav";
files1 = [];
files2 = [];

%right mic
[y1,fs1] = audioread(filenames1(1));
[y2,fs2] = audioread(filenames1(2));
%left mic
[y3,fs1] = audioread(filenames2(1));
[y4,fs2] = audioread(filenames2(2));

%read in files
% for i = 1:length(filenames)
%     
%     [y1,fs1] = audioread(filenames1(i));
%     [y2,fs2] = audioread(filenames2(i));
% 
%     files1 = [files1 y1]; 
%     files2 = [files2 y2];
% end

%make the recordings the same length
% len = 48000; % a 1 second window 
len = min([length(y1), length(y2), length(y3), length(y4)]);
y1 = y1(1:len,1);
y2 = y2(1:len,1); 
y3 = y3(1:len,1);
y4 = y4(1:len,1); 

%averaging to normalise proximity effects 
[dev1,f,t] = spectrogram(y1,window_length,overlap,fft_freqs,Fs,'yaxis');
[dev2,f,t] = spectrogram(y3,window_length,overlap,fft_freqs,Fs,'yaxis');
devs = abs((dev1 + dev2) / 2);

elle1 = spectrogram(y2,window_length,overlap,fft_freqs,Fs,'yaxis');
elle2 = spectrogram(y2,window_length,overlap,fft_freqs,Fs,'yaxis');
elles = (elle1 + elle2) / 2;

ave_len = Fs*50; %average over 1/4 second intervals
for i = 1%floor(len/ave_len)
    
%     if (isempty(tot))
%         tot = spectrogram(y1(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
%     else
%         tot1 = spectrogram(y1(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
%         tot2 = spectrogram(y3(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
%         tot = (tot1 + tot2) / 2;
%     end
%     ylim([0.1 5]);
%     title('Dev');

% 
figure();
    hold on
    subplot(211), spectrogram(y1(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
    subplot(211), spectrogram(y3(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
    ylim([0.1 15]);
    title('Dev');

    hold on
    subplot(212), spectrogram(y2(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
    subplot(212), spectrogram(y4(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
    ylim([0.1 15]);
    title('Elle');
end

% tot = tot/40;
%imshow(tot)

% 
% %create a test sample with music+silence+speech
% y6 = [y1(1:round(len/3)); y3(round(len/3):round(2*len/3)); y5(round(len/3):round(2*len/3)); y1(round(len/3):round(2*len/3))];
% 
% %Testing: break array into subarrays of 100000 samples each and determine
% %zero-cross freq for that chunk
% y7 = zeros(length(y6),1);
% plot(y6);
% hold on;
% 
% num_sections = 20;
% steps = round(length(y6)/num_sections);
% for i=0:num_sections-1
%     index = (i*steps)+1;
%     test = y6(index:index+steps);
%     y6_zeros = 0;
%     
%     for j=2:length(test)
%         if(sign(test(j-1)) ~= sign(test(j)))
%             y6_zeros =y6_zeros+1;
%         end
%     end
%     y7(index:index+steps) = steps/y6_zeros;
% end
% 
% 
% 
% %use thresholds
% for i=1:length(y7)
%   if(y7(i)<20)
%       y7(i) = 1;
%   elseif (y7(i)<35)
%       y7(i) = 2;
%   else
%       y7(i) = 3;
%   end 
% end
% 
% fprintf('1 = Speech\n');
% fprintf('2 = Silence\n');
% fprintf('3 = Music\n');
% 
% soundsc(y6, fs1);
% 
% plot(y7);