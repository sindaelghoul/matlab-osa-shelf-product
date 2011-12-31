close all;
figure(23);
imshow(shelves);
segmentedShelf = uint8(zeros(size(shelves,1),size(shelves,2)));
offset = 10;

bitmap = shelves_details.SURF.bitmap;
ind = find(bitmap > 0);
shelfSURFdesc = shelves_details.SURF.pts(1,bitmap(ind));
D1 = reshape([shelfSURFdesc.descriptor],64,[]); 
totalMatches = tic;
for ii=1:productIndex.Length
    productSURFdesc = productIndex.SURF.Products(ii).pts;
    
    D2 = reshape([productSURFdesc.descriptor],64,[]); 
    
    % Find the best matches
    err=zeros(1,length(shelfSURFdesc));
    cor1=1:length(shelfSURFdesc); 
    cor2=zeros(1,length(shelfSURFdesc));
    for i=1:length(shelfSURFdesc),
        distance=sum((D2-repmat(D1(:,i),[1 length(productSURFdesc)])).^2,1);
        [err(i),cor2(i)]=min(distance);
    end
    
    % Sort matches on vector distance
    [err, ind]=sort(err);
    
    err = err(err < 0.18);
    
    cor1=cor1(ind); 
    cor2=cor2(ind);
    
    cor1=cor1(1:size(err,2)); 
    cor2=cor2(1:size(err,2));
    
    
    % Show the best matches
    for i=1:size(cor1,2),
        %c=rand(1,3);
        x = shelfSURFdesc(cor1(i)).x;
        y = shelfSURFdesc(cor1(i)).y;
        
        leftOffset = max(0,x-offset);
        rightOffset = min(x+offset,size(shelves,2));
        upperOffset = max(0,y-offset);
        bottomOffset = min(y+offset,size(shelves,1));
        
        segmentedShelf(upperOffset:bottomOffset,leftOffset:rightOffset) = 255;
        %plot([shelfSURFdesc(cor1(i)).x],[shelfSURFdesc(cor1(i)).y],'o','Color',c)
    end
end
disp(['total matches : '  num2str(toc(totalMatches)) 'seconds']);

%%
se = strel('disk', offset/2);
I_opened = imdilate(segmentedShelf,se);
shelves_morph = bwareaopen(I_opened, offset*4*9*4);


s  = regionprops(shelves_morph, 'BoundingBox');
figure(23);hold on; 
for i=1:size(s,1)
    rectangle('Position',s(i).BoundingBox,'EdgeColor' ,'green', 'LineWidth',4,'LineStyle','--');
end
