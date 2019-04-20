function pr = power_ratio(y, sample_size, num_samples)

    pr = zeros(num_samples,1);

    for i = 1:num_samples-1
        arr_start = (i-1)*(sample_size)+1;
        arr_end = arr_start+sample_size;
        temp = y(arr_start:arr_end);
        pr(i) = bandpower(temp, 48000, [150 250])/bandpower(temp, 48000, [50 150]);

    end

end