clear;

%get dem tracks
%specify sampling frequency
Fs = 48000;
window_length = 2000;%48000*10;
overlap = 10;
fft_freqs = 20000; 
max_fft_samples = 48000;
silence_thresh = 0.3;
transient_thresh = 0.25;

filenames = ["Dev1.m4a", "Dev2.m4a", "Dev3.m4a", "Elle1.m4a", "Elle2.mp4", "Silence.m4a"];%, "DevElleDiff", "DevElleSame", "silence", "testingVariety"];
filepaths = '../sound_recs/mono_' + filenames;

%right mic
[y1,fs1] = audioread(filepaths(1));
[y2,fs2] = audioread(filepaths(4));
[y3,fs3] = audioread(filepaths(6));

    y1 = remove_transients(y1, transient_thresh);
    y2 = remove_transients(y2, transient_thresh);
    y3 = remove_transients(y3, transient_thresh);

prior_marker = "";
markers = [];
this_marker_start = 1;

% for listening_to = 1:length(filenames)
% 
%     [clip,fs1] = audioread(filepaths(listening_to));

%     % remove transients
%     clip = remove_transients(clip, transient_thresh);
%     
%     % normalise volume
%     clip = normalize(clip);
%     
%     return
% end

%make the recordings the same length
% len = 48000; % a 1 second window 
% len = min([length(y1), length(y2), length(y3)]);
% y1 = y1(1:len,1);
% y2 = y2(1:len,1); 
% y3 = y3(1:len,1);
% y4 = y4(1:len,1); 

ave_len = Fs*50; %average over 1/4 second intervals
% for i = 1%floor(len/ave_len)
%     
% %     if (isempty(tot))
% %         tot = spectrogram(y1(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
% %     else
% %         tot1 = spectrogram(y1(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
% %         tot2 = spectrogram(y3(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
% %         tot = (tot1 + tot2) / 2;
% %     end
% %     ylim([0.1 5]);
% %     title('Dev');
% 
% % 
%     figure();
%     hold on
%     subplot(131), spectrogram(y1(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power')
%     colormap HSV
% %     subplot(211), spectrogram(y3(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
%     ylim([50/1000 250/1000]);
%     title('Dev');
%     caxis([-140 -20])
% 
%     hold on
%     subplot(132), spectrogram(y2(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
% %     subplot(212), spectrogram(y4(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
%     ylim([50/1000 250/1000]);
%     title('Elle');
%     caxis([-140 -20])
%     
%     subplot(133), spectrogram(y3,window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
% %     subplot(212), spectrogram(y4(1+(ave_len*(i-1)):ave_len*i,1),window_length,overlap,fft_freqs,Fs,'yaxis', 'power');
%     ylim([50/1000 250/1000]);
%     title('Silence');
%     caxis([-140 -20])
% end
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

for listening_to = 1:length(filenames)

    [clip,fs1] = audioread(filepaths(listening_to));
    
    % remove transients
    clip = remove_transients(clip, transient_thresh);
    
    % normalise volume
%     clip = normalize(clip);
    
    %% To check what clips look like before and after silence removal
    %     figure();
    %     hold on
    %     plot(clip)
    %     remove silence
    %     clip = remove_silence(clip, silence_thresh);
    %     plot(clip)
    %     continue

%     clip = remove_silence(clip, silence_thresh);

    % basic low pass to remove noise introduced by downsampling
%     clip = movmean(clip, 100);
%     soundsc(clip,48000)
%     return
% figure()

    % take as many snippets from the clip as possible
    % MAYBE MAKE INTO SLIDING WINDOW RATHER THAN JUMPING? - Dev
    for k = 1:floor(length(clip)/max_fft_samples)
        % extract segment for each smear
        start_sample = ((k-1) * max_fft_samples) + 1;
        end_sample = (k * max_fft_samples);
        this_snippet = clip(start_sample:end_sample);
        
        % make and save spectrograms
        spectrogram(this_snippet,window_length,overlap,fft_freqs,Fs,'yaxis', 'power')
        colormap HSV
        caxis([-140 -20])
        ylim([50/1000 250/1000]);
       
%         if (k>8)
%             return;
%         end

        % are we looking at Dev or Elle?
        this_marker = extractBefore(filenames(listening_to), 4);
        if (this_marker ~= prior_marker)
            this_marker_start = listening_to;
            prior_marker = extractBefore(filenames(listening_to), 4);
            markers = [markers prior_marker];
        end
        
        outputfilename = char('../smeared_ffts/' + prior_marker + '/' + k*(listening_to));% + '.png');
        set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
        set(gca,'box','off')
        axis off
        colorbar('off');
        set(gca,'LooseInset',get(gca,'TightInset'));
        print(outputfilename, '-dpng', '-noui');
%         saveas(gca,outputfilename)
%         imwrite(smear, outputfilename);
    end
end

for q = 1:length(markers)
    zip('../smeared_ffts/' + markers(q) + '.zip','../smeared_ffts/' + markers(q));
end