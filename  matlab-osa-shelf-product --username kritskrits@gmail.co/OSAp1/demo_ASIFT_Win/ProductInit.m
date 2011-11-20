function [ productIndex product ] = ProductInit( product_FileLocation )
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
BWdfill = imfill(I_opened, 'holes');
%figure(3), imshow(BWdfill), title('product after morphological close/open');

%productViewsLabled = bwlabel(BWdfill,4);

productIndex.product = product;
productIndex.productRP = regionprops(BWdfill, 'Centroid','BoundingBox');

%get average height
productIndex.Length = size(productIndex.productRP);
height = [];
for ii=1:productIndex.Length
    height = [height productIndex.productRP(ii).BoundingBox(4)];
end
productIndex.avgHeightPX = mean(height);

end

