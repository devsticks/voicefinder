%right mic
[y1,fs1] = audioread('../sound_recs_aligned/mic1_Dev.wav');
[y2,fs2] = audioread('../sound_recs_aligned/mic1_Elle.wav');
%left mic
[y3,fs3] = audioread('../sound_recs_aligned/mic2_Dev.wav');
[y4,fs4] = audioread('../sound_recs_aligned/mic2_Elle.wav');
%other
[y5,fs5] = audioread('../sound_recs_aligned/mic2_silence.wav');
[y6,fs6] = audioread('../sound_recs/Jolene.m4a');

len = 2000000;
power_ratio_thresh = 5;

close all;

%create a test sample with mixture of music/silence/Elle/Dev
%y6 = [y1(1:round(len/3));y4(round(len/3):round(2*len/3)); y5(1:round(len)); y6(1:round(len/4)); y3(round(len/3):round(len)); y2(round(len/3):round(2*len/3))];
%dev, elle, silence, music, dev, elle
y6 = [y1(1:round(len));y4(1:round(len)); y5(1:round(len)); y6(1:round(len)); y3(1:round(len)); y2(1:round(len))];
%[y6,fs6] = audioread('../sound_recs_aligned/mic2_testingVariety.wav');
y7 = zeros(length(y6),1);
plot(y6, 'DisplayName', 'Test data');
hold on;

num_sections = 36; %num sections to analyse
steps = floor(length(y6)/num_sections);
for i=0:num_sections-1
    index = (i*steps)+1;
    
    test = y6(index:index+steps -1);
    
    zero_cross_freq = zero_cross(test);
    zcf_inv = 1/zero_cross_freq;
    power_ratio = bandpower(test, 48000, [150 250])/bandpower(test, 48000, [50 150]);
    fprintf('%0.5f\n',i);
    if(zcf_inv<20)
        %Speech
        if(power_ratio<=power_ratio_thresh)
            %Dev
            %fprintf('dev: zcf: %0.5f, pr: %0.5f\n',zcf_inv, power_ratio);
            y7(index:index+steps) = 1;
        else
            %Elle
            %fprintf('elle: zcf: %0.5f, pr: %0.5f\n',zcf_inv, power_ratio);
            y7(index:index+steps) = 2;
        end 
    elseif (zcf_inv<35)
        %silence
        %fprintf('silence: zcf: %0.5f, pr: %0.5f\n',zcf_inv, power_ratio);
        y7(index:index+steps) = 3;
    else
        %music
        %fprintf('music: zcf: %0.5f, pr: %0.5f\n',zcf_inv, power_ratio);
        y7(index:index+steps) = 4;
    end    
end

plot(y7, 'DisplayName', 'Classification');
legend

fprintf('1 = Speech: Devin\n');
fprintf('2 = Speech: Elle\n');
fprintf('3 = Silence\n');
fprintf('4 = Music\n');

