clear;

%specify sampling frequency
snippet_length = 1; % in seconds
Fs = 48000;
window_length = 2000;%48000*10;
overlap = 10;
fft_freqs = 20000; 
max_fft_samples = snippet_length*Fs;
silence_thresh = 0.3;
transient_thresh = 0.25;

%get dem tracks
filenames = ["OthMaleReading3.m4a", "OthJason.m4a", "OthFemaleReading1.m4a"];
filepaths = '../sound_recs/' + filenames;

prior_marker = "";
markers = [];
this_marker_start = 1;

ave_len = Fs*50; %average over 1/4 second intervals

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
    for k = 2:floor(length(clip)/(max_fft_samples/(2*snippet_length))) - (2*snippet_length) % 1/2 second stride
        % extract segment for each smear
        start_sample = ((k-1) * (max_fft_samples/(2*snippet_length))) + 1; % start every 1/2 second
        end_sample = start_sample + max_fft_samples; %(k * max_fft_samples); % capture 1 second worth
        this_snippet = clip(start_sample:end_sample);
        
        % make and save spectrograms
        spectrogram(this_snippet,window_length,overlap,fft_freqs,Fs,'yaxis', 'power')
        colormap HSV
        caxis([-140 -20])
        ylim([50/1000 250/1000]);

        % are we looking at Dev or Elle?
        this_marker = extractBefore(filenames(listening_to), 4);
        if (this_marker ~= prior_marker)
            this_marker_start = listening_to;
            prior_marker = extractBefore(filenames(listening_to), 4);
            markers = [markers prior_marker];
        end
        
        % put figure together for export
        outputfilename = char('../smeared_ffts/' + prior_marker + '/' + k*(listening_to));% + '.png');
        set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
        set(gca,'box','off')
        axis off
        colorbar('off');
        set(gca,'LooseInset',get(gca,'TightInset'));
        print(outputfilename, '-dpng', '-noui');
        
        break;
    end
end

for q = 1:length(markers)
    zip('../smeared_ffts/' + markers(q) + '.zip','../smeared_ffts/' + markers(q));
end