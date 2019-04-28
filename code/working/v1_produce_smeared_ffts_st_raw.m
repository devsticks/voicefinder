%% Takes in stereo audio files, and produces images of smeared 
%% FFTs over the specified freqs, and puts them into zip files for uploading

clear;

%specify sampling frequency
Fs = 48000;

% set fft bounds
lowerbnd = 50; % hertz
upperbnd = 250;
max_fft_samples = 48000; % 1 second

filenames = ["Dev", "Elle", "DevElleDiff", "DevElleSame", "silence", "testingVariety"];
filenames1 = '../../sound_recs_aligned/mic1_' + filenames + '.wav';
filenames2 = '../../sound_recs_aligned/mic2_' + filenames + '.wav';
files1 = [];
files2 = [];

% take 1-second samples for every Mic 1 recording and write images of 
% smeared ffts to respective folders
for listening_to = 1:2%length(filenames)
    
    % combine mics and fix lengths
    [mic1,fs1] = audioread(filenames1(listening_to));
    [mic2,fs1] = audioread(filenames2(listening_to));
    rec_length = min(length(mic1), length(mic2));
    clip = (mic1(1:rec_length) + mic2(1:rec_length))/2;

    % take as many snippets from the clip as possible
    % MAYBE MAKE INTO SLIDING WINDOW RATHER THAN JUMPING? - Dev
    for k = 1:floor(length(clip)/max_fft_samples)
        % extract segment for each smear
        start_sample = ((k-1) * max_fft_samples) + 1;
        end_sample = (k * max_fft_samples);
        this_snippet = clip(start_sample:end_sample);

        % make and save smears
        smear = fft_smear(Fs, lowerbnd, upperbnd, max_fft_samples, this_snippet);
        figure();
        imshow(smear);         
        if (k>4)
            return;
        end
        outputfilename = char('../../smeared_ffts/' + filenames(listening_to) + '/' + k + '.png');
        imwrite(smear, outputfilename);
    end
    
    zip('../../smeared_ffts/' + filenames(listening_to) + '.zip', '../../smeared_ffts/' + filenames(listening_to));
end