%%
clear all;clc;close all;
%%
product_FileLocation = 'coffee_namess.jpg';
shelves_FileLocation = 'shelf.jpg';
shelfColor_FileLocation = 'shelfCropped.jpg';
shelfEmptyColor_FileLocation = 'empty.jpg';

product = imread(product_FileLocation);
shelves = imread(shelves_FileLocation);

saveFileAs_subImg1 = 'productExample.jpg';
saveFileAs_subImg2 = 'shelfExample.jpg';

productExampleIndex = 2;
shelfWindowIndex = 1;

productIndex = ProductInit(product);
%%
[ shelfObject ] = shelfDetectInit( shelves , shelfColor_FileLocation,shelfEmptyColor_FileLocation,true );
%%
shelves_details = shelfDetect( shelfObject , true , false );
%%
[rect_prod sub_product] = ProductGetByIndex(productIndex,productExampleIndex,[]);
routeIndex  = SWinit(rect_prod ,shelves);

colorPlate=hsv(100);
figure();imshow(shelves); hold on;
while (~routeIndex.bDoneJob)
    [ routeIndex,rect_shelf ] = SWsaveJPG( routeIndex,[] );
    rectangle('Position',rect_shelf,'EdgeColor',colorPlate(randi(100),:));
    [ routeIndex ] = SWadvance( routeIndex );
end