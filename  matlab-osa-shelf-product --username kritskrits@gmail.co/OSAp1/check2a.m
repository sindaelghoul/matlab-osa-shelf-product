clear all; close all;



% Find corner features in grayscale image.
%% 
% First generate a corner metric matrix.

 I = imread('maxwell gold.png');
%  I = I(1:150,1:120);
 subplot(1,3,1);
 imshow(I);
 title('Original Image');
 IG=rgb2gray(I);
 CM = cornermetric(IG);

%%
% Adjust corner metric for viewing.
CM_adjusted = imadjust(CM);
subplot(1,3,2);
imshow(CM_adjusted);
title('Corner Metric');


%%
% Find and display some corner features.
corner_peaks = imregionalmax(CM);
corner_idx = find(corner_peaks == true);
[r g b] = deal(IG);
r(corner_idx) = 255;
g(corner_idx) = 255;
b(corner_idx) = 0;
RGB = cat(3,r,g,b);
subplot(1,3,3);
imshow(RGB);
title('Corner Points');

%% get target image
 ITC = imread('I0031.jpg');
 %  I = I(1:150,1:120);
 figure;
 subplot(1,3,1);
 imshow(ITC);
 title('Target Image');
 ITG=rgb2gray(ITC);
 CM = cornermetric(ITG);
