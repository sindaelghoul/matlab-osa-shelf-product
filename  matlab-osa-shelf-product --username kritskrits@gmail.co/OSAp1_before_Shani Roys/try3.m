 %  from - matchFeatures of R2011a:

 I1 = rgb2gray(imread('maxwellG.png'));
 I2 = rgb2gray(imread('A0032.png'));
  
 %% Find corners  
   hcornerdet = corner(I1, 200);
   hcornerdet2 = corner(I2, 200);
%    hcornerdet = vision.CornerDetector('MaximumCornerCount', 200);
   
%dbg
figure;
imshow(I1);
hold on
plot(hcornerdet(:,1), hcornerdet(:,2), 'r*');

pause;
figure;
imshow(I2);
hold on
plot(hcornerdet2(:,1), hcornerdet2(:,2), 'r*');
% dbg end

   [points1, count1] = step(hcornerdet, I1);
   [points2, count2] = step(hcornerdet, I2);
  
 %% Pack point sets - points1 and points2 are a 
 % 2-by-MaximumCornerCount matrices containing zero entries when 
 % count < MaximumCornerCount
   points1 = points1(:, 1:count1);
   points2 = points2(:, 1:count2);
   
 %% Extract neighborhood features
   [features1, valid_points1] = extractFeatures(I1, points1);
   [features2, valid_points2] = extractFeatures(I2, points2);
  
 %% Match features
   index_pairs = matchFeatures(features1, features2);
  
 %% Retrieve locations of corresponding points for each image
   matched_points1 = valid_points1(:, index_pairs(1, :));
   matched_points2 = valid_points2(:, index_pairs(2, :));
  
 %% Visualize corresponding points
   cvexShowMatches(I1, I2, matched_points1, matched_points2, ...
       'viprectification\_deskLeft', 'viprectification\_deskRight');
 
