function [ routeIndex ] = SWinit(productIndex,shelfObject,rect_prod ,shelves)
    %% Calculate the size and the route progress of the sliding window
    
    %%
    routeIndex.bDoneJob = false;
    routeIndex.bAdvance = false;
    routeIndex.shelves = shelves;
    
    initProductSize = [rect_prod(3) rect_prod(4)];
    routeIndex.shelvesSize = [size(shelves(1,:,1),2) size(shelves(:,1,1),1)];

    routeIndex.WindowSizePx = initProductSize * 2; % double the size of the product
    routeIndex.AdvanceOffset = initProductSize;

    routeWindowX = routeIndex.AdvanceOffset(1) - routeIndex.WindowSizePx(1); %double the size
    routeWindowY = routeIndex.shelvesSize(2) - routeIndex.AdvanceOffset(2); %double the size

    routeIndex.WindowInitial = [routeWindowX routeWindowY];
    routeIndex.Window = routeIndex.WindowInitial;
    routeIndex.index = [1 1];
end

