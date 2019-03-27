%realign recodings so that they both start at the clap 
[y1,fs1] = audioread('mic1_Elle.m4a');
[y2,fs2] = audioread('mic2_Elle.m4a');

%find the clap in each
y1_start = round(mean(find(y1>(0.9999)*max(y1))));
y2_start = round(mean(find(y2>(0.9999)*max(y2))));

y1 = y1(y1_start:length(y1));
y2 = y2(y2_start:length(y2));

%make the recordings the same length
len = min(length(y1), length(y2));
y1 = y1(:,1); y1 = y1(1:len);
y2 = y2(:,1); y2 = y2(1:len);

%find the position of a maxima within a certain range in both
y1_pos = mean(find(y1(2000:round(len*0.05))==max(y1(2000:round(len*0.05)))));
y2_pos = mean(find(y2(2000:round(len*0.05))==max(y2(2000:round(len*0.05)))));

diff_pos = y2_pos-y1_pos;

stem(y2(71000:round(len*0.0136)));
hold on;
stem(y1(71000:round(len*0.0136)));
hold off;