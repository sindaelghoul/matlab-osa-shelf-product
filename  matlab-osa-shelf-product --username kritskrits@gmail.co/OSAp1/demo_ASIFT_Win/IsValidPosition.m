function [ bValid ] = IsValidPosition( rectangle , bitmap , precent )
    bValid = true;
    subBitMap = imcrop(bitmap,rectangle);
    if( sum(sum(subBitMap)) > (rectangle(3)*rectangle(4)*precent))
        bValid = false;
    end
end

