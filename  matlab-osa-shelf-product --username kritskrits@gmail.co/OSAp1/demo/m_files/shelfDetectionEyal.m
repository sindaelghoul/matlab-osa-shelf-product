clear all; clc; close all;
%% shelf detection
shelf = imread('_____0045.jpg');
shelfExample = imread('shelfCropped.jpg');
%shelfExample = imread('empty.jpg');


cform = makecform('srgb2lab');
shelfCIELAB = applycform(shelf,cform);
shelfExampleCIELAB = applycform(shelfExample,cform);

subplot(2,1,1);
imshow(shelf), title('shelf');

%nColors = 6;
%sample_regions = false([size(product,1) size(product,2) nColors]);

%for count = 1:nColors
%  sample_regions(:,:,count) = roipoly(product,region_coordinates(:,1,count),...
%                                      region_coordinates(:,2,count));
%end

%imshow(sample_regions(:,:,2)),title('sample region for red');

a = shelfExampleCIELAB(:,:,2);
b = shelfExampleCIELAB(:,:,3);
color_marker = zeros([1, 2]);

color_marker(1) = mean2(a);
color_marker(2) = mean2(b);




% 0 = background, 1 = red, 2 = green, 3 = purple, 4 = magenta, and 5 = yellow.

%color_labels = 0:nColors-1;

%Initialize matrices to be used in the nearest neighbor classification.
a = double(shelfCIELAB(:,:,2));
b = double(shelfCIELAB(:,:,3));
distance = zeros([size(a)]);

%Perform classification
distance = ( (a - color_marker(1)).^2 + (b - color_marker(2)).^2 ).^0.5;

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

subplot(2,1,2);
imshow(segmented_images);

%% mathematical morphology
close all;
%subplot(3,1,1);
figure(5),imshow(segmented_images);

productViewsLabled = imfill(segmented_images, 'holes');
figure(6),imshow(productViewsLabled);

%se = strel('rectangle', [5 2]);
se = strel('disk',4);
I_opened = imerode(productViewsLabled,se);
%subplot(3,1,2);
figure(7),imshow(I_opened);

se = strel('rectangle', [5 20]);
%se = strel('disk',4);
I_opened = imopen(I_opened,se);
%subplot(3,1,2);
figure(9),imshow(I_opened);


se = strel('rectangle', [35 300]);
I_closed = imclose(I_opened,se);
figure(10),imshow(I_closed);

se = strel('rectangle', [5 20]);
I_opened = imerode(I_closed,se);
figure(11),imshow(I_opened);

shelves_morph = bwareaopen(I_opened, 250);

%subplot(3,1,3);
figure(12),imshow(shelves_morph);
%%
s = regionprops(shelves_morph, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid' , 'BoundingBox');
figure(2) ,imshow(shelves_morph);


%phi = linspace(0,2*pi,50);
%cosphi = cos(phi);
%sinphi = sin(phi);

figure(99);imshow(shelf), title('shelf');
for k = 1:length(s)
   
    theta = pi*s(k).Orientation/180
    width=s(k).BoundingBox(3)
    height=s(k).BoundingBox(4)
    
    if(abs(s(k).Orientation) > 30 |  (height > 0.9*width))
        continue;
    end
    
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
    hold on;plot(XY(1,:),XY(2,:),'black','LineWidth',1);
    
    %lineX = [0 size(shelf,2)];
    %deg = theta;
    %lineY = tan(deg).*lineX -tan(deg).*xbar + ybar;
    %hold on; line(lineX,lineY);
    
    
    

end
hold off


