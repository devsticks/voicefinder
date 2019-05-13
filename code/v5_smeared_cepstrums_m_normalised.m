%% Takes in mono audio files, removes silence and produces images of smeared 
%% FFTs over the specified freqs, and puts them into zip files for uploading

clear;

%specify sampling frequency
Fs = 48000;
silence_thresh = 0.3;
transient_thresh = 0.25;

% set fft bounds
lowerbnd = 50; % hertz
upperbnd = 250;
max_fft_samples = 480; % 1 second

filenames = ["Dev1.m4a", "Dev2.m4a", "Dev3.m4a", "Elle1.m4a", "Elle2.mp4", "Silence.m4a"];%, "DevElleDiff", "DevElleSame", "silence", "testingVariety"];
filepaths = '../sound_recs/mono_' + filenames;

% take 1-second samples for every recording and write images of 
% smeared ffts to respective folders
prior_marker = "";
markers = [];
this_marker_start = 1;

for listening_to = 1:length(filenames)

    [clip,fs1] = audioread(filepaths(listening_to));
    
    % remove transients
    clip = remove_transients(clip, transient_thresh);
    
    % normalise volume
    clip = normalize(clip);
    k=6;
    start_sample = ((k-1) * (max_fft_samples/2)) + 1; % start every 1/2 second
        end_sample = start_sample+max_fft_samples;%(k * max_fft_samples); % capture 1 second worth
        this_snippet = clip(start_sample:end_sample);
    plot(rceps(this_snippet))
    xlim([0 50]);
    return
    
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

% length(clip)
% max_fft_samples
% floor(length(clip)/(max_fft_samples/2))-2
% 
% return

    % take as many snippets from the clip as possible
    % MAYBE MAKE INTO SLIDING WINDOW RATHER THAN JUMPING? - Dev
    for k = 1:floor(length(clip)/(max_fft_samples/2))-2 % 1/2 second stride
        % extract segment for each smear
        start_sample = ((k-1) * (max_fft_samples/2)) + 1; % start every 1/2 second
        end_sample = start_sample+max_fft_samples;%(k * max_fft_samples); % capture 1 second worth
        this_snippet = clip(start_sample:end_sample);

        % make and save smears
        smear = fft_smear(Fs, lowerbnd, upperbnd, max_fft_samples, this_snippet);
%         figure();
%         imshow(smear);         
%         if (k>8)
%             return;
%         end

        % are we looking at Dev, Elle or silence?
        this_marker = extractBefore(filenames(listening_to), 4);
        if (this_marker ~= prior_marker)
            this_marker_start = listening_to;
            prior_marker = extractBefore(filenames(listening_to), 4);
            markers = [markers prior_marker];
        end
        
        outputfilename = char('../smeared_ffts/' + prior_marker + '/' + k*(listening_to) + '.png');
        imwrite(smear, outputfilename);
    end
end

for q = 1:length(markers)
    zip('../smeared_ffts/' + markers(q) + '.zip','../smeared_ffts/' + markers(q));
end