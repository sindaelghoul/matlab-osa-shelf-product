clear all;clc;clear all;
%% read matching data from file
fid = fopen('matchings.txt');

%read number of matches
matches = cell2mat(textscan(fid, '%d',1));
% read numeric data
C_data = textscan(fid, '%d %d %d %d',1);
for k = 1 : matches - 1
    C_data = [C_data;textscan(fid, '%d %d %d %d',1)];
end

C_data = cell2mat(C_data);

fclose(fid);

%% create contoured data from product views
%clear all;clc;close all;
product = imread('coffee_namess.jpg');
%figure(1), imshow(product), title('product');


bw = im2bw(product,0.9);
%figure(2), imshow(bw), title('product bw');

se = strel('rectangle', [5 5]);
I_closed = imclose(bw,se);
se = strel('rectangle', [15 15]);
I_opened = imopen(I_closed,se);
I_opened = ~I_opened;
BWdfill = imfill(I_opened, 'holes');
%figure(3), imshow(BWdfill), title('product after morphological close/open');

productViewsLabled = bwlabel(BWdfill,4);


s = regionprops(BWdfill, 'Centroid');
colorSpace = char('blue','green','red','cyan','magenta','yellow','black');
figure(4), imshow(product), title('product with Centroid Locations');
hold on
numObj = numel(s);
%indexing the product views
for k = 1 : numObj
    %plot(s(k).Centroid(1), s(k).Centroid(2), 'b*');
    text(s(k).Centroid(1),s(k).Centroid(2),sprintf('%d', k),'FontSize', 25 ,'FontWeight','bold','BackgroundColor',[.7 .9 .7],'Color', colorSpace(k,:));
end

%painting the matched ASIFT cordinates
for k = 1 : matches
    if (productViewsLabled(C_data(k,2), C_data(k,1)) > 0)
        %plot(C_data(k,1), C_data(k,2), strcat(colorSpace(productViewsLabled(C_data(k,2), C_data(k,1)),:),'*')); 
        C_data(k,5) = 1;
    else
        %plot(C_data(k,1), C_data(k,2), 'black*','MarkerSize',30);
        C_data(k,5) = 0;
    end
end
hold off
 

%% shelf compare
shelf = imread('mySt.JPG');

cform = makecform('srgb2lab');
shelfCIELAB = applycform(shelf,cform);
productCIELAB = applycform(product,cform);

figure(5), imshow(shelf), title('shelf with matched ASIFT cordinates');
hold on
%painting the matched ASIFT cordinates
for k = 1 : matches
    %if (productViewsLabled(C_data(k,4), C_data(k,3)) > 0)
    if (C_data(k,5) == 0)
        plot(C_data(k,3), C_data(k,4), 'black*','MarkerSize',10); %out of product bounds
    else
        
        rect_shelf = [C_data(k,3)-3 C_data(k,4)-3 7 7];
        rect_prod = [C_data(k,1)-3 C_data(k,2)-3 7 7];
        
        sub_shelf = imcrop(shelfCIELAB,rect_shelf);
        sub_prod = imcrop(productCIELAB,rect_prod);
        
        if(isempty(sub_shelf))
            continue;
        end
        
        lS = mean2(sub_shelf(:,:,1));
        aS = mean2(sub_shelf(:,:,2));
        bS = mean2(sub_shelf(:,:,3));

        lP = mean2(sub_prod(:,:,1));
        aP = mean2(sub_prod(:,:,2));
        bP = mean2(sub_prod(:,:,3));

        %aDbS = aS/bS;
        lDaS = lS/aS;
        %lDbS = lS/bS;
        %aDbP = aP/bP;
        lDaP = lP/aP;
        %lDbP = lP/bP;
        
        aAbS = abs(aS-bS);
        %lAaS = abs(lS-aS);
        %lAbS = abs(lS-bS);
        aAbP = abs(aP-bP);
        %lAaP = abs(lP-aP);
        %lAbP = abs(lP-bP);
        
        ratioAbsDiff = min(aAbS,aAbP) / max(aAbS,aAbP);
        ratioDiv = min(lDaS,lDaP) / max(lDaS,lDaP);
        ratioL = min(lS,lP) / max(lS,lP);
  
        

        if (ratioL < 0.4 | ratioAbsDiff < 0.35 | ratioDiv < 0.55)
            %plot(C_data(k,1), C_data(k,2), '--rs','MarkerSize',30);
        else
            plot(C_data(k,3), C_data(k,4), strcat(colorSpace(productViewsLabled(C_data(k,2), C_data(k,1)),:),'*'),'MarkerSize',20);
        end
    end
end
hold off

%% ncc
%[xmin ymin width height]
%rect_shelf = [455-2 120-2 5 5];
%rect_prod = [153-2 100-2 5 5];

%rect_shelf = [910-2 173-2 5 5];
%rect_prod = [299-2 133-2 5 5];

rect_shelf = [1289-2 451-2 5 5];
rect_prod = [248-2 874-2 5 5];


%rect_shelf = [1459-2 252-2 5 5];
%rect_prod = [334-2 867-2 5 5];

%rect_shelf = [1827-2 120-2 5 5];
%rect_prod = [48-2 849-2 5 5];

sub_shelf = imcrop(shelf,rect_shelf);
sub_prod = imcrop(product,rect_prod);

cform = makecform('srgb2lab');
sub_shelf = applycform(sub_shelf,cform);
sub_prod = applycform(sub_prod,cform);

lS = mean2(sub_shelf(:,:,1));
aS = mean2(sub_shelf(:,:,2));
bS = mean2(sub_shelf(:,:,3));

lP = mean2(sub_prod(:,:,1));
aP = mean2(sub_prod(:,:,2));
bP = mean2(sub_prod(:,:,3));

%aDbS = abs(aS-bS)
%lDaS = abs(lS-aS)
%lDbS = abs(lS-bS)

%aDbP = abs(aP-bP)
%lDaP = abs(lP-aP)
%lDbP = abs(lP-bP)

%aDbS = aS/bS
%lDaS = lS/aS
%lDbS = lS/bS
%aDbP = aP/bP
%lDaP = lP/aP
%lDbP = lP/bP

aDbS = aS/aP
lDaS = bS/bP
lDbS = lS/lP



subplot(2, 2, 1)
imshow(sub_shelf), title('shelf cropped');
subplot(2, 2, 2)
imshow(sub_prod), title('product cropped');

rS = sub_shelf(:,:,1);
gS = sub_shelf(:,:,2);
bS = sub_shelf(:,:,3);

rP = sub_prod(:,:,1);
gP = sub_prod(:,:,2);
bP = sub_prod(:,:,3);
subplot(2, 2, 3)
plot3(rS(:),gS(:),bS(:),'.')
grid('on')
xlabel('L (Band 3)')
ylabel('A (Band 2)')
zlabel('B (Band 1)')
title('Scatterplot of Shelf')

subplot(2, 2, 4)
plot3(rP(:),gP(:),bP(:),'.')
grid('on')
xlabel('L (Band 3)')
ylabel('A (Band 2)')
zlabel('B (Band 1)')
title('Scatterplot of Product')




%c = normxcorr2(sub_shelf,sub_prod);
%figure, surf(c), shading flat

%% k-means
opts = statset('Display','final');
[idx,ctrs] = kmeans(double([C_data(:,3) C_data(:,4)]),numObj,'Distance','cityblock','Replicates',15,'Options',opts);

for k = 1 : numObj
    plot(ctrs(k,1),ctrs(k,2), 'y*' ,'MarkerSize',12);
    %%text(idx(k,1),idx(k,2),sprintf('%d', k),'FontSize', 25 ,'FontWeight','bold','BackgroundColor',[.7 .9 .7],'Color', colorSpace(mod(k,numObj)+1,:));
end

%% CIELAB

product = imread('mySp30pC.jpg');
figure(1), imshow(product), title('product');

load regioncoordinates;

nColors = 6;
sample_regions = false([size(product,1) size(product,2) nColors]);

for count = 1:nColors
  sample_regions(:,:,count) = roipoly(product,region_coordinates(:,1,count),...
                                      region_coordinates(:,2,count));
end

%imshow(sample_regions(:,:,2)),title('sample region for red');

cform = makecform('srgb2lab');
lab_product = applycform(product,cform);

a = lab_product(:,:,2);
b = lab_product(:,:,3);
color_markers = zeros([nColors, 2]);

for count = 1:nColors
  color_markers(count,1) = mean2(a(sample_regions(:,:,count)));
  color_markers(count,2) = mean2(b(sample_regions(:,:,count)));
end



% 0 = background, 1 = red, 2 = green, 3 = purple, 4 = magenta, and 5 = yellow.

color_labels = 0:nColors-1;

%Initialize matrices to be used in the nearest neighbor classification.
a = double(a);
b = double(b);
distance = zeros([size(a), nColors]);

%Perform classification
for count = 1:nColors
  distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
                      (b - color_markers(count,2)).^2 ).^0.5;
end

[value, label] = min(distance,[],3);
label = color_labels(label);
clear value distance;

%Display Results of Nearest Neighbor Classification
rgb_label = repmat(label,[1 1 3]);
segmented_images = repmat(uint8(0),[size(product), nColors]);

for count = 1:nColors
  color = product;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end

imshow(segmented_images(:,:,:,1)), title('red objects');

