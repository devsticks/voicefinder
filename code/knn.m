close all; clear all;

%right mic
[y1,fs1] = audioread('../sound_recs_aligned/mic1_Dev.wav');
[y2,fs2] = audioread('../sound_recs_aligned/mic1_Elle.wav');
[y9,fs9] = audioread('../sound_recs_aligned/mic1_DevElleDiff.wav');

%left mic
[y3,fs3] = audioread('../sound_recs_aligned/mic2_Dev.wav');
[y4,fs4] = audioread('../sound_recs_aligned/mic2_Elle.wav');
[y10,fs10] = audioread('../sound_recs_aligned/mic2_DevElleDiff.wav');

%other
[y6,fs6] = audioread('../sound_recs/Jolene.m4a');
[y7,fs7] = audioread('../sound_recs_aligned/mic1_silence.wav');
[y8,fs8] = audioread('../sound_recs_aligned/mic2_silence.wav');
y7 =[y7;y8];

len = 4000000;

%dev
y1 = y1(1:len,1);
y3 = y3(1:len,1);

%elle
y2 = y2(1:len,1);
y4 = y4(1:len,1);

%other 
y6 = y6(1:len,1);
y7 = y7(1:len,1);
y9 = y9(1:len,1);
y10 = y10(1:len,1);

%split into 0.5 second pieces and claculate zero crossing rate and power ratio for each 

sample_duration = 8000; %duration of sample size in milliseconds
sample_size = fs1*sample_duration/1000; %number of samples per chunk
num_samples = floor(len/sample_size); %numer of chunk

zc1 = log(zero_cross_samples(y1, sample_size, num_samples));
zc2 = log(zero_cross_samples(y2, sample_size, num_samples));
zc3 = log(zero_cross_samples(y3, sample_size, num_samples));
zc4 = log(zero_cross_samples(y4, sample_size, num_samples));
zc6 = log(zero_cross_samples(y6, sample_size, num_samples));
zc7 = log(zero_cross_samples(y7, sample_size, num_samples));
zc9 = log(zero_cross_samples(y9, sample_size, num_samples));
zc10 = log(zero_cross_samples(y10, sample_size, num_samples));

pr1 = log(power_ratio(y1, sample_size, num_samples));
pr2 = log(power_ratio(y2, sample_size, num_samples));
pr3 = log(power_ratio(y3, sample_size, num_samples));
pr4 = log(power_ratio(y4, sample_size, num_samples));
pr6 = log(power_ratio(y6, sample_size, num_samples));
pr7 = log(power_ratio(y7, sample_size, num_samples));
pr9 = log(power_ratio(y9, sample_size, num_samples));
pr10 = log(power_ratio(y10, sample_size, num_samples));

elle_matrix = [[zc2;zc4],[pr2;pr4]];
dev_matrix = [[zc1;zc3],[pr1;pr3]];
music_matrix = [zc6,pr6];
silence_matrix = [[zc7],[pr7]];
develle_matrix = [[zc9;zc10],[pr9;pr10]];

hold on;

scatter(elle_matrix(:,1),elle_matrix(:,2), 'r', 'filled');
scatter(dev_matrix(:,1),dev_matrix(:,2),'b', 'filled');
scatter(music_matrix(:,1),music_matrix(:,2),'g', 'filled');
scatter(silence_matrix(:,1),silence_matrix(:,2),'k', 'filled');
%scatter(develle_matrix(:,1),develle_matrix(:,2),'m', 'filled');

xlabel('log of the zero-cross frequency') 
ylabel('log of the power ratio') 

legend('Elle','Devin','Music','Silence','Location','Best');


%------------------------------KNN classifier-----------------------
%---------training data-----------------

training = [elle_matrix; dev_matrix; music_matrix; silence_matrix];
group = zeros(length(training),1);
group(1:length(elle_matrix)) = 1; index = length(elle_matrix);
group(index+1:index+length(dev_matrix)) = 2; index = index + length(dev_matrix);
group(index+1:index+length(music_matrix)) = 3; index = index + length(music_matrix);
group(index+1:index+length(silence_matrix)) = 4; index = index + length(silence_matrix);

%---------testing samples---------------
len = 4000000;
y_test = [y1(1:round(len));y4(1:round(len)); y7(1:round(len)); y6(1:round(len)); y3(1:round(len)); y2(1:round(len))];

num_samples = floor(length(y_test)/sample_size); %numer of chunks

zc_test = log(zero_cross_samples(y_test, sample_size, num_samples));
pr_test = log(power_ratio(y_test, sample_size, num_samples));

sample = [zc_test, pr_test];

%---------Train and predict-----------------

model = fitcknn(training, group,'NumNeighbors',2);
classes = predict(model, sample);

% for i = 1: length(classes)
%     if(classes(i) == 4)
%         scatter(sample(i,1), sample(i,2),'m', 'filled');
%     end
% end

y_class = zeros(length(y_test),1);
steps = floor(length(y_test)/num_samples);
for i = 1: length(classes)
    index = ((i-1)*steps)+1;
    y_class(index: index+steps) = classes(i);
end

figure; hold on;
plot(y_test, 'DisplayName', 'Test data');
plot(y_class, 'DisplayName', 'Classification');


fprintf('1 = Speech: Devin\n');
fprintf('2 = Speech: Elle\n');
fprintf('3 = Music\n');
fprintf('4 = Silence\n');



