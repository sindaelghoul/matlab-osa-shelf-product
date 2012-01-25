function ShowColorSegmentation( sw,shelves_details,productIndex )
    figure(555);
    %shelf
    shelfWindow = sw.shelf.shelfWindow;
    shelfLabWindow = sw.shelf.shelfLabWindow;
    %color
    subplot(3,5,1);
    imshow(shelfWindow);
    hold on;plot((sw.shelf.rightOffset-sw.shelf.leftOffset)/2,(sw.shelf.bottomOffset-sw.shelf.upperOffset)/2,'o','Color','white');

    %histogram color
    subH = subplot(3,5,2);
    [sCr,sCb,sCg] = rgbhist(shelfWindow,subH);

    %cielab
    subplot(3,5,3);
    imshow(shelfLabWindow);

    %histogram cielab
    subH = subplot(3,5,4);
    [sLl,sLa,sLb] = rgbhist(shelfLabWindow,subH);

    %orientation
    subplot(3,5,5);
    shelfPresentationOffset = 100;
    %leftOffset = max(sw.shelf.x - offset,0);
    %upOffset = min(sw.shelf.y - offset,size(shelves_details.shelfObject.shelves,1));
    rect = [sw.shelf.x - shelfPresentationOffset,sw.shelf.y - shelfPresentationOffset,2*shelfPresentationOffset,2*shelfPresentationOffset];
    croppedShelf = imcrop(shelves_details.shelfObject.shelves,rect);
    imshow(croppedShelf);
    hold on;rectangle('Position',[shelfPresentationOffset-(sw.shelf.rightOffset-sw.shelf.leftOffset)/2,shelfPresentationOffset - (sw.shelf.bottomOffset-sw.shelf.upperOffset)/2,(sw.shelf.rightOffset-sw.shelf.leftOffset),(sw.shelf.bottomOffset-sw.shelf.upperOffset)],'EdgeColor','white');

    %product
    productWindow = sw.product.productWindow;
    productLabWindow = sw.product.productLabWindow;
    
    %color
    subplot(3,5,6);
    imshow(productWindow);
    hold on;plot((sw.product.rightOffset-sw.product.leftOffset)/2,(sw.product.bottomOffset-sw.product.upperOffset)/2,'o','Color','white');

    %histogram color
    subH = subplot(3,5,7);
    [pCr,pCg,pCb] = rgbhist(productWindow,subH);

    %cielab
    subplot(3,5,8);
    imshow(productLabWindow);

    %histogram cielab
    subH = subplot(3,5,9);
    [pLl,pLa,pLb] = rgbhist(productLabWindow,subH);

    %orientation
    subplot(3,5,10);
    imshow(productIndex.Products(1,sw.product.index).product);
    %hold on;plot(sw.shelf.x,sw.shelf.y,'o','Color','white');
    hold on;rectangle('Position',[sw.product.x-(sw.shelf.rightOffset-sw.shelf.leftOffset)/2,sw.product.y - (sw.shelf.bottomOffset-sw.shelf.upperOffset)/2,(sw.shelf.rightOffset-sw.shelf.leftOffset),(sw.shelf.bottomOffset-sw.shelf.upperOffset)],'EdgeColor','white');

    %histogram
    %color
    subH = subplot(3,5,12);
    rgbhistDelta(shelfWindow,productWindow,subH);
    %cielab
    subH = subplot(3,5,14);
    rgbhistDelta(shelfLabWindow,productLabWindow,subH);

end



