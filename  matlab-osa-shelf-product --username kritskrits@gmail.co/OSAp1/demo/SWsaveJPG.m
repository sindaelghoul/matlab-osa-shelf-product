function [ routeIndex,rect_shelf ] = SWsaveJPG( routeIndex,saveFileAs_subImg2 )

routeWindowX = routeIndex.Window(1);
routeWindowY = routeIndex.Window(2);

actualWindowPositionX = routeWindowX;
actualWindowPositionY = routeWindowY;

actualWindowSizeX = routeIndex.WindowSizePx(1);
actualWindowSizeY = routeIndex.WindowSizePx(2);

if(routeWindowX < 0) %exeeding image size
    actualWindowPositionX = 0;
    actualWindowSizeX = mod(routeWindowX,routeIndex.WindowSizePx(1));
elseif(routeWindowX > routeIndex.shelvesSize(1)) %exeeding image size
    routeIndex.bAdvance = true;
    actualWindowPositionX = routeIndex.WindowInitial(1); %advance
end

if((routeWindowY + routeIndex.WindowSizePx(2)) < 0) %exeeding image size
    routeIndex.bDoneJob = true; %% quit with appropriate message
elseif(routeWindowY + routeIndex.WindowSizePx(2) > routeIndex.shelvesSize(2)) %exeeding image size
    actualWindowPositionY = routeWindowY;
    actualWindowSizeY = mod(routeIndex.shelvesSize(2) - routeWindowY,routeIndex.WindowSizePx(2)); 
end

% writing the cropped shelves
rect_shelf = [actualWindowPositionX actualWindowPositionY actualWindowSizeX actualWindowSizeY];
sub_shelf = imcrop(routeIndex.shelves,rect_shelf);
rect_shelf(3) = size(sub_shelf,2);
rect_shelf(4) = size(sub_shelf,1);

%routeIndex.Window = [actualWindowPositionX actualWindowPositionY];

if(~isempty(saveFileAs_subImg2) && ~isempty(sub_shelf))
    imwrite(sub_shelf,saveFileAs_subImg2,'jpg','Quality',100);
    return;
end

%figure;imshow(sub_shelf);



end

