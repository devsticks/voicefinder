%% Removes samples above threshold
%% Use with LPF to account for downsampling effect aliasing

function out = remove_transients(clip, upp_thresh)
    out = [];
    for n = 1:length(clip)
       if (abs(clip(n)) < upp_thresh)
           out = [out; clip(n)];
       end
    end
end