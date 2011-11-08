close all;
%% shelf detection
shelf = imread('_____0031.jpg');
%shelfExample = imread('shelfCropped.jpg');
shelfExample = imread('empty.jpg');


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


lDaS = aS./bS;

lDaP = aP./bP;
%lDbP = lP/bP;


ratioDiv = lDaS ./ lDaP;
ratioL = lS ./ lP;
  
        
%Display Results of Nearest Neighbor Classification
segmentedShelf = repmat(uint8(0),[size(a)]);

%segmented_images(distance < 1) = 255;
absRatioL = abs(ratioL-1);
absRatioDiv = abs(ratioDiv-1);
beforeChange = segmentedShelf;
segmentedShelf2  = segmentedShelf;

%l / a > 1.1
segmentedShelf2(ratioDiv > 0.999 & ratioDiv < 1.0001) = 255;
figure(135),imshow(segmentedShelf2);

%segmentedShelf2(ratioL > 1) = 255;
%figure(135),imshow(segmentedShelf2);
%segmentedShelf(absRatioL < 0.05) = 255;
%figure(136),imshow(segmentedShelf);

%newShelf = segmentedShelf2-segmentedShelf;


%segmentedShelf(ratioL > 1.05) = 255;




%wholeSegmentedShelf = newShelf;
%figure(1337),imshow(wholeSegmentedShelf);
%se = strel('disk',2);
%I_opened = imdilate(wholeSegmentedShelf,se);
%se = strel('disk',3);
%I_opened = imerode(I_opened,se);
%%figure(1338),imshow(I_opened);
%sizeOfBannedBlobs = floor(size(wholeSegmentedShelf,1)*size(wholeSegmentedShelf,2)*0.002);
%wholeSegmentedShelf_morph = bwareaopen(I_opened, sizeOfBannedBlobs);
%wholeSegmentedShelf_labeled = bwlabel(wholeSegmentedShelf_morph, 4);
%figure(1339),imshow(wholeSegmentedShelf_labeled);