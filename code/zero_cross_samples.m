function zc_samps = zero_cross_samples(y, sample_size, num_samples)

    zc_samps = zeros(num_samples,1);
   
    for i = 1:num_samples-1
        arr_start = (i-1)*(sample_size)+1;
        arr_end = arr_start+sample_size;

        zc_samps(i) = zero_cross(y(arr_start:arr_end));

    end

end