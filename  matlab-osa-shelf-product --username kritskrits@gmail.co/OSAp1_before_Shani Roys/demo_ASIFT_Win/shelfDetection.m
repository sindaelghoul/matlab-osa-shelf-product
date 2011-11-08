clear all; clc; close all;
%% shelf detection
shelfLocation = 'shelf.jpg';
shelf = imread(shelfLocation);
shelfExample = imread('shelfCropped.jpg');
%shelfExample = imread('empty.jpg');


cform = makecform('srgb2lab');
shelfCIELAB = applycform(shelf,cform);
shelfExampleCIELAB = applycform(shelfExample,cform);

subplot(1,2,1);
imshow(shelf), title('shelf');

%nColors = 6;
%sample_regions = false([size(product,1) size(product,2) nColors]);

%for count = 1:nColors
%  sample_regions(:,:,count) = roipoly(product,region_coordinates(:,1,count),...
%                                      region_coordinates(:,2,count));
%end

%imshow(sample_regions(:,:,2)),title('sample region for red');

%a = shelfExampleCIELAB(:,:,2);
%b = shelfExampleCIELAB(:,:,3);
%color_marker = zeros([1, 2]);

%color_marker(1) = mean2(a);
%color_marker(2) = mean2(b);




% 0 = background, 1 = red, 2 = green, 3 = purple, 4 = magenta, and 5 = yellow.

%color_labels = 0:nColors-1;

%Initialize matrices to be used in the nearest neighbor classification.
a = double(shelfCIELAB(:,:,1));
%b = double(shelfCIELAB(:,:,3));
distance = zeros([size(a)]);

%Perform classification
%distance = ( (a - color_marker(1)).^2 + (b - color_marker(2)).^2 ).^0.5;

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
segmented_images = repmat(uint8(0),[size(a)]);

%segmented_images(distance < 1) = 255;
absRatioL = abs(ratioL-1);
absRatioDiv = abs(ratioDiv-1);
%segmented_images(absRatioL < 0.02) = 255;
segmented_images(ratioL > 1) = 255;

subplot(1,2,2);
imshow(segmented_images);

%% mathematical morphology
%close all;
%subplot(3,1,1);
%figure(5),imshow(segmented_images);

productViewsLabled = imfill(segmented_images, 'holes');
%figure(6),imshow(productViewsLabled);

%se = strel('rectangle', [5 2]);
se = strel('disk',4);
I_opened = imerode(productViewsLabled,se);
%subplot(3,1,2);
%figure(7),imshow(I_opened);

se = strel('rectangle', [5 20]);
%se = strel('disk',4);
I_opened = imopen(I_opened,se);
%subplot(3,1,2);
%figure(9),imshow(I_opened);


se = strel('rectangle', [35 300]);
I_closed = imclose(I_opened,se);
%figure(10),imshow(I_closed);

se = strel('rectangle', [5 20]);
I_opened = imdilate(I_closed,se);
%figure(11),imshow(I_opened);

shelves_morph = bwareaopen(I_opened, 250);
shelves_labeled = bwlabel(shelves_morph, 4);

%subplot(3,1,3);
figure(12),imshow(shelves_morph);
%%
s = regionprops(shelves_morph, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid' , 'BoundingBox');
%figure(2) ,imshow(shelves_morph);


%phi = linspace(0,2*pi,50);
%cosphi = cos(phi);
%sinphi = sin(phi);
avgHeight = 0;
avgHeightIterations = 0;
figure(99);imshow(shelf), title('shelf');
for k = 1:length(s)
   
    theta = pi*s(k).Orientation/180;
    width=s(k).BoundingBox(3);
    height=s(k).BoundingBox(4);
    
    if(abs(s(k).Orientation) > 30 |  (height > 0.4*width) | height < 20)
        shelves_labeledXored = bitxor(shelves_labeled,k);
        shelves_labeled(shelves_labeledXored == 0) = 0;
        continue;
    end
    
    avgHeightIterations = avgHeightIterations+1;
    avgHeight = avgHeight*(avgHeightIterations-1)/avgHeightIterations + s(k).MinorAxisLength /avgHeightIterations ;
    
    %elipse
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    %xy = [a*cosphi; b*sinphi];
    %xy = R*xy;

    %x = xy(1,:) + xbar;
    %y = xy(2,:) + ybar;

    %hold on; plot(x,y,'r','LineWidth',2);
    
    %rectangle('Position', [x y w h])
    w=s(k).BoundingBox(3); %w=s(k).MajorAxisLength; %width
    h=s(k).MinorAxisLength; %height
    x=-w/2;
    y=-h/2; %corner position
    xv=[x x+w x+w x x];
    yv=[y y y+h y+h y];
    %hold on; plot(xv,yv);

    %rotate angle alpha
    Rrect(1,:)=xv;Rrect(2,:)=yv;
    XY=R*Rrect;
    
    deltaX = 0;
    deltaY = 0;
    if (w/2 > xbar)
        deltaX = w/2 - xbar;
        deltaY = deltaX * sin(theta);
    end
    
    XY(1,:) = XY(1,:) + xbar + deltaX;
    XY(2,:) = XY(2,:) + ybar - deltaY;
    hold on;plot(XY(1,:),XY(2,:),'m','LineWidth',2);
    
    
    xv=[-size(shelf,2) size(shelf,2)];
    yv=[0 0];
    %rotate angle alpha
    Rline(1,:)=xv;Rline(2,:)=yv;
    XY=R*Rline;
    if (w/2 > xbar)
        deltaX = w/2 - xbar;
        deltaY = deltaX * sin(theta);
    end
    XY(1,:) = XY(1,:) + xbar + deltaX;
    XY(2,:) = XY(2,:) + ybar - deltaY;
    bar(k).x = XY(1,:);
    bar(k).y = XY(2,:);
    hold on;plot(XY(1,:),XY(2,:),'black','LineWidth',1);
    
    %lineX = [0 size(shelf,2)];
    %deg = theta;
    %lineY = tan(deg).*lineX -tan(deg).*xbar + ybar;
    %hold on; line(lineX,lineY);
    
    
    

end

%figure(999),imshow(shelves_labeled);


%%
wholeSegmentedShelf = emptyShelf(shelfLocation,'empty.jpg');
%figure(1337),imshow(wholeSegmentedShelf);
se1 = strel('rectangle', [2 10]);
I_opened = imerode(wholeSegmentedShelf,se1);
se2 = strel('disk',2);
I_opened = imerode(I_opened,strel('rectangle', [2 2]));
I_opened = imdilate(I_opened,se2);
%figure(1338),imshow(I_opened);
I_opened = imclose(I_opened,se1);

%figure(1338),imshow(I_opened);
sizeOfBannedBlobs = floor(size(wholeSegmentedShelf,1)*size(wholeSegmentedShelf,2)*0.002);
wholeSegmentedShelf_morph = bwareaopen(I_opened, sizeOfBannedBlobs);
wholeSegmentedShelf_labeled = bwlabel(wholeSegmentedShelf_morph, 4);
wholeSegmentedShelf_labeled = imfill(wholeSegmentedShelf_labeled);
%figure(1339),imshow(wholeSegmentedShelf_labeled);

%%

wholeS = regionprops(wholeSegmentedShelf_labeled, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid' , 'BoundingBox');

for k = 1:length(wholeS)
    %figure,imshow(shelves_labeled);
    specific_shelf = not(bitxor(wholeSegmentedShelf_labeled,k));
    %figure,imshow(specific_shelf);
    specific_shelf_Compared = bitand(specific_shelf,shelves_labeled > 0);
    %figure,imshow(specific_shelf_Compared);
    overlapSize = sum(sum(specific_shelf_Compared));
    if(overlapSize > sizeOfBannedBlobs)
        line = zeros(size(specific_shelf_Compared));
        index = max(max(shelves_labeled(specific_shelf_Compared > 0)));

        [myline,mycoords,outmat,X,Y] = bresenham(specific_shelf_Compared,[1,bar(index).y(1);size(specific_shelf_Compared,2),bar(index).y(2)],0);

        se2 = strel('disk',4);
        outmat = imdilate(outmat,se2);
        outmat = imfill(outmat,'holes'); % there might be holes due to crossing line

        [specific_shelf_Compared_labeled numberOfBlobsExceptShelf] = bwlabel(not(outmat), 4);
            
        [n m]= find(specific_shelf_Compared_labeled ~= 2);
        if(size(n,1) > size(specific_shelf_Compared_labeled,1)*size(specific_shelf_Compared_labeled,2)*0.95)
            specific_shelf_Compared_labeled_only_over = specific_shelf_Compared;
        else
            specific_shelf_Compared_labeled_only_over = bitxor(specific_shelf_Compared_labeled,2); 
        end
        
        %specific_shelf_Compared_labeled_only_over = specific_shelf_Compared;
        %if(numberOfBlobsExceptShelf == 2) %its being divided exactly to under and over the shelf
        
            %figure,imshow(specific_shelf_Compared_labeled_only_over);
        %end
        emptySpace = bitxor(specific_shelf,specific_shelf_Compared);
        emptySpace = bitand(specific_shelf_Compared_labeled_only_over,emptySpace);
        %figure,imshow(emptySpace);
        
        %BWoutline = bwperim(emptySpace);
        [r,c]= find(emptySpace > 0);
        hold on;plot(c,r,'green');
        
        se2 = strel('line',avgHeight*0.4,90);
        treshEmptySpace = imopen(emptySpace,se2);
        %BWoutline = bwperim(treshEmptySpace);
        [r,c]= find(treshEmptySpace > 0);
        hold on;plot(c,r,'red');
        
        
        
    end
        
                
     %   shelves_labeled(shelves_labeledXored == 0) = 0;
        
end
hold off

