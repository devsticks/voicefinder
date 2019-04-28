%% Removes samples below threshold
%% Use with LPF to account for downsampling effect aliasing

function out = remove_silence(clip, low_thresh)
    out = [];
    for n = 1:length(clip)
       if (abs(clip(n)) > low_thresh)
           out = [out; clip(n)];
       end
    end
end