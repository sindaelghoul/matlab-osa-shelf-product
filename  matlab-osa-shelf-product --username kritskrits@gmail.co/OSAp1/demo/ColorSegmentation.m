%function [ output_args ] = ColorSegmentation( shelves_details,productIndex )
figure(555);
%shelf
shelfWindow = shelves_details.shelfObject.shelves(sw.upperOffset:sw.bottomOffset,sw.leftOffset:sw.rightOffset,:);
shelfLabWindow = shelves_details.shelfObject.shelfCIELAB(sw.upperOffset:sw.bottomOffset,sw.leftOffset:sw.rightOffset,:);
%color
subplot(3,4,1);
imshow(shelfWindow);

%cielab
subplot(3,4,2);
imshow(shelfLabWindow);

subplot(3,4,3);

%orientation
subplot(3,4,4);
offset = 100;
%leftOffset = max(sw.shelf.x - offset,0);
%upOffset = min(sw.shelf.y - offset,size(shelves_details.shelfObject.shelves,1));
rect = [sw.shelf.x - offset,sw.shelf.y - offset,2*offset,2*offset]
croppedShelf = imcrop(shelves_details.shelfObject.shelves,rect);
imshow(croppedShelf);
hold on;plot(offset,offset,'o','Color','white');
hold on;rectangle('Position',[sw.upperOffset,sw.leftOffset,2*(sw.bottomOffset-sw.upperOffset),2*(sw.rightOffset-sw.leftOffset)]);
        
%product
%color
subplot(3,4,5);
imshow(productIndex.Products(1,sw.product.index).product);
%cielab
subplot(3,4,6);
imshow(productIndex.Products(1,sw.product.index).ProductCIELAB);

subplot(3,4,7);

%orientation
subplot(3,4,8);
imshow(productIndex.Products(1,sw.product.index).product);
hold on;plot(sw.shelf.x,sw.shelf.y,'o','Color','white');

%histogram
%color
subplot(3,4,1);
%cielab
subplot(3,4,2);
subplot(3,4,3);
subplot(3,4,4);
%end

