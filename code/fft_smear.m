function smear = fft_smear(Fs, lower_bound, upper_bound, max_fft_samples, sample)
    % get sample length
    len = min(length(sample), max_fft_samples);
    
    % convert bounds to 'sampled' frequency
    lowerfft = ceil((lower_bound*len)/(2*Fs)); 
    upperfft = floor((upper_bound*len)/(2*Fs));

    % do the fft
    f = abs(fft(sample, len));
    f = f(lowerfft:upperfft);

    % do some blurring...
    f = movmean(f, round(len/10000));

    % smear...
    f1plt = mat2gray(f, [0 max_fft_samples/20]); % set maximum pixel intensity
    smear = repmat(f1plt, 1, length(f1plt));
end