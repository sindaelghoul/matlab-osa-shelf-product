function [ productIndex ] = ProductInit( product )
%% create contoured data from product views
%clear all;clc;close all;
%figure(1), imshow(product), title('product');


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

end

