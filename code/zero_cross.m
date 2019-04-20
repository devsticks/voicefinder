function zc = zero_cross(x)
    len = length(x);
    zc = 0; 

    for i=2:len
        if(sign(x(i-1)) ~= sign(x(i)))
            zc =zc+1;
        end
    end
    
    zc =zc/len;

end