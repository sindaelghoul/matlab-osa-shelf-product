clear all;clc;clear all;
%%
file_img1 = 'coffee_namess.jpg';
file_img2 = 'shelf_namess05.jpg';

product = imread(file_img1);
shelves = imread(file_img2);

saveFileAs_subImg1 = 'example.jpg';
saveFileAs_subImg2 = 'shelf.jpg';

productIndex = 2;
shelfWindowIndex = 1;

%% read the example window

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

productViewsLabled = bwlabel(BWdfill,4);


productRP = regionprops(BWdfill, 'Centroid','BoundingBox');

%% writing the angled product to file
rect_prod = productRP(productIndex).BoundingBox;
sub_product = imcrop(product,rect_prod);
%figure(99);imshow(sub_shelf);
imwrite(sub_product,saveFileAs_subImg1,'jpg','Quality',100);

%%
%colorSpace = char('blue','green','red','cyan','magenta','yellow','black');
%figure(4), imshow(product), title('product with Centroid Locations');
%hold on
numObj = numel(productRP);
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

%% moving window on shelf
%% Init
initWidth = rect_prod(3);
initHeight = rect_prod(4);
shelvesWidth = size(shelves(1,:,1),2);
shelvesHeight = size(shelves(:,1,1),1);
routeWindowX = -1 * initWidth;
routeWindowY = shelvesHeight + initHeight;

%% acutal and update route
if(routeWindowX < 0 || routeWindowX > shelvesWidth) %exeeding image size
    actualWindowX = 
end
actualwindowWidth = initWidth * 2;
actualwindowHeight = initHeight * 2;
%actualWindowX = 
%actualWindowY =



rect_prod = [150 560 100 100];
sub_product = imcrop(product,rect_prod);
figure(99);imshow(sub_product);
%%imwrite(sub_product,saveFileAs_subImg1,'jpg','Quality',100);

