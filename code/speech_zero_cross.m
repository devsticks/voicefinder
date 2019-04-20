%right mic
[y1,fs1] = audioread('../sound_recs_aligned/mic1_Dev.wav');
[y2,fs2] = audioread('../sound_recs_aligned/mic1_Elle.wav');
%left mic
[y3,fs3] = audioread('../sound_recs_aligned/mic2_Dev.wav');
[y4,fs4] = audioread('../sound_recs_aligned/mic2_Elle.wav');

len = 4000000;

y1 = y1(1:len,1);
y4 = y4(1:len,1);

zc_avg1 = zero_cross(y1);
zc_avg4 = zero_cross(y4);


%split into 0.5 second pieces and claculate zero crossing rate for each to
%get varience

sample_duration = 500; %duration of sample size in milliseconds
sample_size = fs1*sample_duration/1000; %number of samples per chunk
num_samples = floor(len/sample_size); %numer of chunks

zc_samps1 = zero_cross_samples(y1, sample_size, num_samples);
zc_samps4 = zero_cross_samples(y4, sample_size, num_samples);

zc_var1 = var(zc_samps1);
zc_var4 = var(zc_samps4);

fprintf('average zero crossings per sample for Dev %0.5f with a variance of %0.5f\n',zc_avg1, zc_var1);
fprintf('average zero crossings per sample for Elle %0.5f with a variance of %0.5f\n',zc_avg4, zc_var4);


close all;
%create a test sample with mixture of Elle/Dev
y6 = [y1(1:round(len/2)); y4(round(1):round(len/2)); y1(round(len/2):round(len)); y4(round(len/2):round(len))];
y6 = [y1(1:round(len));y4(1:round(len)); y1(1:round(len)); y4(1:round(len))];

%Testing: break array into subarrays of 100000 samples each and determine
%zero-cross freq varience for that chunk
y7 = zeros(length(y6),1);
plot(y6, 'DisplayName', 'Test data');
hold on;


num_sections = 8;
steps = floor(length(y6)/num_sections);
for i=0:num_sections-1
    index = (i*steps)+1;
    test = y6(index:index+steps -1);
    
    sample_duration = 500; %duration of sample size in milliseconds
    sample_size = fs1*sample_duration/1000; %number of samples per chunk
    num_samples = floor(length(test)/sample_size); %numer of chunks
    
    zero_cross_var = var(zero_cross_samples(test, sample_size, num_samples));
    %fprintf('var %0.5f\n',zero_cross_var);
    y7(index:index+steps) = zero_cross_var;
    
end

%use thresholds
thresh = (var(zc_samps1)+var(zc_samps4))/2;
for i=1:length(y7)
  if(y7(i)<=thresh)
      y7(i) = 1;
  else
      y7(i) = 3;
  end 
end

plot(y7, 'DisplayName', 'Who is talking?');
legend
fprintf('1 = Sticks\n');
fprintf('3 = Elle\n');

%soundsc(y6, fs1);

