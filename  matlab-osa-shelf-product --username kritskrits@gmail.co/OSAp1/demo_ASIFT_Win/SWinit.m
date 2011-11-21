function [ routeIndex ] = SWinit(routeIndex,productIndex,shelves_details,rect_prod ,shelves)
    global bWasInitSwOnce;    
    if(~bWasInitSwOnce)
        %% Calculate the size and the route progress of the sliding window
        ProductPxInCm = productIndex.avgHeightPX/productIndex.sizeInCM;
        ShelvesPxInCm = shelves_details.shelfGapPixels/shelves_details.shelfObject.sizeInCM;
        routeIndex.bImagesRatio = false;
        routeIndex.ImagesRatio = ShelvesPxInCm/ProductPxInCm;
        if(routeIndex.ImagesRatio > 1.2) %we need to reduce resolution
            disp('Decreasing resolution , might take time...');
            shelves = imresize(shelves, 1/routeIndex.ImagesRatio);
            shelvesSegmented = imresize(shelves_details.sigmentedShelves, 1/routeIndex.ImagesRatio);
            disp('DONE');
            routeIndex.bImagesRatio = true;    
        else if(routeIndex.ImagesRatio < 0.8)%we need to increase resolution
                disp('Increasing resolution , might take time...');
                shelves = iir(shelves_details.shelfObject.shelves_FileLocation,1/routeIndex.ImagesRatio,'method','linear');    
                shelvesSegmented = imresize(shelves_details.sigmentedShelves, 1/routeIndex.ImagesRatio);
            
                disp('DONE');
                routeIndex.bImagesRatio = true;
             end 
        end
        routeIndex.shelves = shelves;
        routeIndex.shelvesSegmented = shelvesSegmented;
        bWasInitSwOnce = true;
    end
    %%
    routeIndex.bDoneJob = false;
    routeIndex.bAdvance = false;
    
    
    initProductSize = [rect_prod(3) rect_prod(4)];
    routeIndex.shelvesSize = [size(routeIndex.shelves(1,:,1),2) size(routeIndex.shelves(:,1,1),1)];

    %routeIndex.WindowSizePx = initProductSize * 2; % double the size of the product
    %routeIndex.AdvanceOffset = initProductSize;
    
    routeIndex.WindowSizePx = initProductSize; % double the size of the product
    routeIndex.AdvanceOffset = initProductSize /2;

    routeWindowX = routeIndex.AdvanceOffset(1) - routeIndex.WindowSizePx(1); %double the size
    routeWindowY = routeIndex.shelvesSize(2) - routeIndex.AdvanceOffset(2); %double the size

    routeIndex.WindowInitial = [routeWindowX routeWindowY];
    routeIndex.Window = routeIndex.WindowInitial;
    routeIndex.index = [1 1];
   
    
    try   
        close(777);
        %close(666);
    catch exception
    end
    
    figure(777);imshow(routeIndex.shelves); hold on; %inside SWinit now
    %figure(666);imshow(routeIndex.shelvesSegmented); hold on; %inside SWinit now
    
    
end

