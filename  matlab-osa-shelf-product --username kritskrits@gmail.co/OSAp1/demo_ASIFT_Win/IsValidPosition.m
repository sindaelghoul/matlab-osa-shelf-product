function [ bValid ] = IsValidPosition( rectangle , bitmap )
    bValid = true;
    subBitMap = imcrop(bitmap,rectangle);
    if( sum(sum(subBitMap)) > (rectangle(3)*rectangle(4)*0.33))
        bValid = false;
    end
end

