function [ rect_prod,sub_product ] = ProductGetByIndex( productIndex,Index, saveFileAs_subImg1 )
    %% writing the angled product to file
    rect_prod = productIndex.productRP(Index).BoundingBox;
    sub_product = imcrop(productIndex.product,rect_prod);
    
    if(~isempty(saveFileAs_subImg1))
        imwrite(sub_product,saveFileAs_subImg1,'jpg','Quality',100);
        return;
    end

    %figure;imshow(sub_product);

    

end

