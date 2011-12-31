%%
clear all;clc;close all;
%%
global bWasInitSwOnce;
global totalMatches;
global bShowSegmentedShelvesWhileSW;
global bDebug;
global SurfOptions;
global num_CPUs;

[s, w] = dos('set NUMBER_OF_PROCESSORS');
num_CPUs = sscanf(w, '%*21c%d', [1, Inf]);

isOpen = matlabpool('size') > 0;
if(~isOpen)
    matlabpool open
    %matlabpool(num_CPUs);
end


% Add subfunctions to Matlab Search path
cd('..\OpenSURF\');
functionname='OpenSurf.m';
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
addpath(functiondir);
addpath([functiondir '/WarpFunctions']);

cd('..\demo\');

SurfOptions.upright=true;
SurfOptions.tresh=0.0001;

bDebug = true;
bCalcEmptyPlace = true;
bShowSegmentedShelvesWhileSW = true;
overLappingPrecentTresh = 0.15;

product_FileLocation = 'pics\newProduct20.jpg';
shelves_FileLocation = 'pics\shelf40.jpg';
shelfColor_FileLocation = 'pics\shelfCropped.jpg';
shelfEmptyColor_FileLocation = 'pics\empty.jpg';

saveFileAs_subImg1 = 'pics\productExample.jpg';
saveFileAs_subImg2 = 'pics\shelfExample.jpg';

% consts needed
totalMatches = 0;
bWasInitSwOnce = false;
productExampleIndex = 2;
shelfWindowIndex = 1;


[shelfObject shelves] = shelfDetectInit( shelves_FileLocation , shelfColor_FileLocation,shelfEmptyColor_FileLocation );
shelves_details = shelfDetect( shelfObject , bCalcEmptyPlace ); %bools = debug,Calculate free space on shelf

[productIndex] = ProductInit(product_FileLocation,shelves_details); %plus fix resolution

[ shelves_details ] = FindSURFonSegmentedShelf( shelves_details );

[ productIndex ] = FindSURFonProduct( productIndex )

colorPlate=hsv(100);
routeIndex = [];
%figure(777);imshow(routeIndex.shelves); hold on; %inside SWinit now

matchPoints = [];
overallTime = tic;
for ii=1:productIndex.Length
    productTime = tic;
    [rect_prod sub_product] = ProductGetByIndex(productIndex,ii,saveFileAs_subImg1);
    
    if(bDebug)
        figure(666); imshow(productIndex.product);
        figure(666); hold on; rectangle('Position',rect_prod,'EdgeColor' ,'green', 'LineWidth',4,'LineStyle','--');
    end
    
    routeIndex = SWinit(routeIndex,productIndex,shelves_details,rect_prod ,shelves);
    a = 1;
    while (~routeIndex.bDoneJob)
        [ routeIndex,rect_shelf ] = SWsaveJPG( routeIndex,saveFileAs_subImg2 );
        
        while(~IsValidPosition( rect_shelf , routeIndex.shelvesSegmented , overLappingPrecentTresh ))
            [ routeIndex ] = SWadvance( routeIndex );
            [ routeIndex,rect_shelf ] = SWsaveJPG( routeIndex,saveFileAs_subImg2 );      
        end
        
               
        if((rect_shelf(3) > rect_prod(3)) && (rect_shelf(4) > rect_prod(4)))
            if(bShowSegmentedShelvesWhileSW)
                if(bDebug)
                    genColor = colorPlate(randi(100),:);
                    %figure(777); hold on;rectangle('Position',rect_shelf,'EdgeColor',genColor);
                    figure(1),subplot(2,3,4);hold on;rectangle('Position',rect_shelf,'EdgeColor',genColor);title({'shelves and empty';'places positions'});
                end
                %figure(666); hold on;rectangle('Position',rect_shelf,'EdgeColor',colorPlate(randi(100),:));
            end
            
            results = RunASIFTandSaveResults(ii,rect_shelf, saveFileAs_subImg1, saveFileAs_subImg2);
            matchPoints = [matchPoints; results];
        end

        
        [ routeIndex ] = SWadvance( routeIndex );
        a= a+1;
        disp(['total matches : ' num2str(totalMatches)]);
    end
    disp(['product #' num2str(ii) ' took ' num2str(toc(productTime)) 'seconds']);
end
disp(['the whole process took ' num2str(toc(overallTime)) 'seconds']);