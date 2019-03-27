
%get dem tracks
[y1,fs1] = audioread('mic1_Dev.m4a');
[y2,fs2] = audioread('mic1_Elle.m4a');
[y3,fs3] = audioread('mic2_silence.m4a');
[y5,fs5] = audioread('Jolene.m4a');


%find the clap in each
y1_start = round(mean(find(y1>(0.9999)*max(y1))));
y2_start = round(mean(find(y2>(0.9999)*max(y2))));
y3_start = round(mean(find(y3>(0.9999)*max(y3))));

y1 = y1(y1_start:length(y1));
y2 = y2(y2_start:length(y2));
y3 = y3(y3_start:length(y3));
y5 = y5(1000000:length(y5));


%make the recordings the same length
len = min(min(length(y1), length(y2)), length(y3));
y1 = y1(:,1); y1 = y1(1:len);
y2 = y2(:,1); y2 = y2(1:len);
y3 = y3(:,1); y3 = y3(1:len);
y5 = y5(:,1); y5 = y5(1:len);

%find zero crossings for y1
y1_zero = 0; y2_zero = 0; y3_zero = 0; y5_zero = 0;

for i=2:len
    if(sign(y1(i-1)) ~= sign(y1(i)))
        y1_zero =y1_zero+1;
    end
    if(sign(y2(i-1)) ~= sign(y2(i)))
        y2_zero =y2_zero+1;
    end
    if(sign(y3(i-1)) ~= sign(y3(i)))
        y3_zero =y3_zero+1;
    end
    if(sign(y5(i-1)) ~= sign(y5(i)))
        y5_zero =y5_zero+1;
    end
end

fprintf('zero cross frequency for y1 (speech Dev):  %0.5f\n',len/y1_zero);
fprintf('zero cross frequency for y2 (speech Elle):  %0.5f\n',len/y2_zero);
fprintf('zero cross frequency for y3 (silence):  %0.5f\n',len/y3_zero);
fprintf('zero cross frequency for y5 (music):  %0.5f\n',len/y5_zero);

%create a test sample with music+silence+speech
y6 = [y1(1:round(len/3)); y3(round(len/3):round(2*len/3)); y5(round(len/3):round(2*len/3)); y1(round(len/3):round(2*len/3))];

%Testing: break array into subarrays of 100000 samples each and determine
%zero-cross freq for that chunk
y7 = zeros(length(y6),1);
plot(y6);
hold on;

num_sections = 20;
steps = round(length(y6)/num_sections);
for i=0:num_sections-1
    index = (i*steps)+1;
    test = y6(index:index+steps);
    y6_zeros = 0;
    
    for j=2:length(test)
        if(sign(test(j-1)) ~= sign(test(j)))
            y6_zeros =y6_zeros+1;
        end
    end
    y7(index:index+steps) = steps/y6_zeros;
end



%use thresholds
for i=1:length(y7)
  if(y7(i)<20)
      y7(i) = 1;
  elseif (y7(i)<35)
      y7(i) = 2;
  else
      y7(i) = 3;
  end 
end

fprintf('1 = Speech\n');
fprintf('2 = Silence\n');
fprintf('3 = Music\n');


plot(y7);