%specify sampling frequency
Fs = 48000;

filenames = ["Dev", "Elle", "DevElleDiff", "DevElleSame", "silence", "testingVariety"];
filenames1 = "../sound_recs/mic1_" + filenames + ".m4a";
filenames2 = "../sound_recs/mic2_" + filenames + ".m4a";

for i = 1:length(filenames)
    %read in files
    [y1,fs1] = audioread(filenames1(i));
    [y2,fs2] = audioread(filenames2(i));

    [y1o, y2o] = align(y1,y2);

    %write new aligned files
    audiowrite(char(strcat("../sound_recs_aligned/mic1_", filenames(i), ".wav")),y1o,Fs);
    audiowrite(char(strcat("../sound_recs_aligned/mic2_", filenames(i), ".wav")),y2o,Fs);
end

function [y1o, y2o] = align(y1,y2)
    %find the clap in each
    y1_start = round(mean(find(y1>(0.9999)*max(y1))));
    y2_start = round(mean(find(y2>(0.9999)*max(y2))));

    y1 = y1(y1_start:length(y1));
    y2 = y2(y2_start:length(y2));

    %make the recordings the same length
    len = min(length(y1), length(y2));
    y1 = y1(:,1); 
    y1o = y1(1:len);
    y2 = y2(:,1); 
    y2o = y2(1:len);

    %find the position of a maxima within a certain range in both
    y1_pos = mean(find(y1(2000:round(len*0.05))==max(y1(2000:round(len*0.05)))));
    y2_pos = mean(find(y2(2000:round(len*0.05))==max(y2(2000:round(len*0.05)))));

    diff_pos = y2_pos-y1_pos;
    
%     stem(y2o(71000:round(len*0.0136)));
%     hold on;
%     stem(y1o(71000:round(len*0.0136)));
%     hold off;
end