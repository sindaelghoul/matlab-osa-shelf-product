%%
clear all;clc;close all;
%%
global bWasInitSwOnce;
global totalMatches;

totalMatches = 0;
bWasInitSwOnce = false;
product_FileLocation = 'newProduct20.jpg';
shelves_FileLocation = 'shelf40.jpg';
shelfColor_FileLocation = 'shelfCropped.jpg';
shelfEmptyColor_FileLocation = 'empty.jpg';

saveFileAs_subImg1 = 'productExample.jpg';
saveFileAs_subImg2 = 'shelfExample.jpg';

productExampleIndex = 2;
shelfWindowIndex = 1;

[productIndex product] = ProductInit(product_FileLocation);
[shelfObject shelves] = shelfDetectInit( shelves_FileLocation , shelfColor_FileLocation,shelfEmptyColor_FileLocation,true );
%%
shelves_details = shelfDetect( shelfObject , true , false ); %bools = debug,Calculate free space on shelf
%%
colorPlate=hsv(100);
routeIndex = [];
%figure(777);imshow(routeIndex.shelves); hold on; %inside SWinit now

matchPoints = [];
overallTime = tic;
for ii=1:productIndex.Length
    productTime = tic;
    [rect_prod sub_product] = ProductGetByIndex(productIndex,ii,saveFileAs_subImg1);
    routeIndex = SWinit(routeIndex,productIndex,shelves_details,rect_prod ,shelves);
    a = 1;
    while (~routeIndex.bDoneJob)
        [ routeIndex,rect_shelf ] = SWsaveJPG( routeIndex,saveFileAs_subImg2 );
               
        if((rect_shelf(3) > rect_prod(3)) && (rect_shelf(4) > rect_prod(4)))
            figure(777); hold on;rectangle('Position',rect_shelf,'EdgeColor',colorPlate(randi(100),:));
            results = RunASIFTandSaveResults(ii,rect_shelf, saveFileAs_subImg1, saveFileAs_subImg2);
            matchPoints = [matchPoints; results];
        end

        [ routeIndex ] = SWadvance( routeIndex );
        a= a+1;
        disp(['total matches : ' num2str(totalMatches)]);
    end
    disp(['product #' num2str(ii) ' took ' num2str(toc(overallTime)) 'seconds']);
end
disp(['the whole process took ' num2str(toc(overallTime)) 'seconds']);