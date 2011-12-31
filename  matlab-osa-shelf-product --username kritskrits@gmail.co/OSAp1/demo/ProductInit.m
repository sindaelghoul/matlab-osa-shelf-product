function [ productIndex ] = ProductInit( product_FileLocation , shelves_details )
    %% create contoured data from product views
    %clear all;clc;close all;
    %figure(1), imshow(product), title('product');

    product = imread(product_FileLocation);

    idx = regexp(product_FileLocation,'\d+');
    nums = regexp(product_FileLocation,'\d+','match');
    productIndex.sizeInCM = str2num(nums{end});

    bw = im2bw(product,0.9);
    %figure(2), imshow(bw), title('product bw');

    se = strel('rectangle', [5 5]);
    I_opened = imopen(bw,se);
    I_closed = imclose(I_opened,se);
    se = strel('disk', 1);
    I_opened = imdilate(I_closed,se);
    I_opened = ~I_opened;
    productSegmatned = imfill(I_opened, 'holes');
    %figure(3), imshow(BWdfill), title('product after morphological close/open');

    %productViewsLabled = bwlabel(BWdfill,4);

    productIndex.productRP = regionprops(productSegmatned, 'Centroid','BoundingBox');
    productIndex.product = product;
    %get average height
    productIndex.Length = size(productIndex.productRP,1);
    height = [];
    for ii=1:productIndex.Length
        height = [height productIndex.productRP(ii).BoundingBox(4)];
    end
    productIndex.avgHeightPX = mean(height);


    %% Calculate the size and the route progress of the sliding window
    ProductPxInCm = productIndex.avgHeightPX/productIndex.sizeInCM;
    ShelvesPxInCm = shelves_details.shelfGapPixels/shelves_details.shelfObject.sizeInCM;
    productIndex.bImagesRatio = false;
    productIndex.ImagesRatio = ShelvesPxInCm/ProductPxInCm;
    ImagesRatio = productIndex.ImagesRatio;
    if(ImagesRatio > 1.2) %we need to increase product resolution
        disp('Increasing product resolution , might take time...');
        productIndex.product = iir(product_FileLocation,ImagesRatio,'method','linear');
        productIndex.bImagesRatio = true; 
    else
        if(ImagesRatio < 0.8)%we need to reduce product resolution
            disp('Decreasing product resolution , might take time...');
            productIndex.product = imresize(productIndex.product, ImagesRatio);
            productIndex.bImagesRatio = true; 
        end
    end
    if(productIndex.bImagesRatio)
        productSegmatned = imresize(productSegmatned, ImagesRatio);
        disp('DONE');
    end
 
    productIndex.productRP = regionprops(productSegmatned, 'Centroid','BoundingBox');

    %get average height
    productIndex.Length = size(productIndex.productRP,1);
    height = [];
    for ii=1:productIndex.Length
        height = [height productIndex.productRP(ii).BoundingBox(4)];
    end
    productIndex.avgHeightPX = mean(height);
  
end

