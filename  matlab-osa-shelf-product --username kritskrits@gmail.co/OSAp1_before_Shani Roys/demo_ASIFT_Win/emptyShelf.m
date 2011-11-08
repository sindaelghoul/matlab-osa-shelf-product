function [ segmentedShelf ] = emptyShelf( shelf,shelfExample )
%% shelf detection
shelf = imread(shelf);
%shelfExample = imread('shelfCropped.jpg');
shelfExample = imread(shelfExample);


cform = makecform('srgb2lab');
shelfCIELAB = applycform(shelf,cform);
shelfExampleCIELAB = applycform(shelfExample,cform);


a = double(shelfCIELAB(:,:,1));

lS = double(shelfCIELAB(:,:,1));
aS = double(shelfCIELAB(:,:,2));
bS = double(shelfCIELAB(:,:,3));

lP = mean2(shelfExampleCIELAB(:,:,1));
aP = mean2(shelfExampleCIELAB(:,:,2));
bP = mean2(shelfExampleCIELAB(:,:,3));


lDaS = lS./aS;

lDaP = lP./aP;
%lDbP = lP/bP;


ratioDiv = lDaS ./ lDaP;
ratioL = lS ./ lP;
  
        
%Display Results of Nearest Neighbor Classification
segmentedShelf = repmat(uint8(0),[size(a)]);

%segmented_images(distance < 1) = 255;
absRatioL = abs(ratioL-1);
absRatioDiv = abs(ratioDiv-1);
%segmented_images(absRatioL < 0.02) = 255;
segmentedShelf(ratioDiv > 1.1) = 255;


end

