function [shelfDetails] = shelfDetect( shelfObject , bDebug ,bCalculateEmptySpace)
    %%
    shelfDetails.shelfObject = shelfObject;
    shelfDetail =[];
    %bDebug = true;
    %% mathematical morphology
    %close all;
    %subplot(3,1,1);
    %figure(5),imshow(segmented_images);

    productViewsLabled = imfill(shelfObject.segmented, 'holes');
    %figure(6),imshow(productViewsLabled);

    %se = strel('rectangle', [5 2]);
    se = strel('disk',4);
    I_opened = imerode(productViewsLabled,se);
    %subplot(3,1,2);
    %figure(7),imshow(I_opened);

    se = strel('rectangle', [5 20]);
    %se = strel('disk',4);
    I_opened = imopen(I_opened,se);
    %subplot(3,1,2);
    %figure(9),imshow(I_opened);


    se = strel('rectangle', [35 300]);
    I_closed = imclose(I_opened,se);
    %figure(10),imshow(I_closed);

    se = strel('rectangle', [5 20]);
    I_opened = imdilate(I_closed,se);
    %figure(11),imshow(I_opened);

    shelves_morph = bwareaopen(I_opened, 250);
    shelves_labeled = bwlabel(shelves_morph, 4);

    %subplot(3,1,3);
    if(bDebug)
     figure(1),subplot(2,3,5);imshow(shelves_morph);title({'shelf detect after';'basic operations'});
    end
    %%
    s = regionprops(shelves_morph, 'Orientation', 'MajorAxisLength', ...
        'MinorAxisLength', 'Eccentricity', 'Centroid' , 'BoundingBox');
    %figure(2) ,imshow(shelves_morph);


    phi = linspace(0,2*pi,50);
    cosphi = cos(phi);
    sinphi = sin(phi);
    avgHeight = 0;
    avgHeightIterations = 0;
    
    if(bDebug)
        figure(99);imshow(shelfObject.shelves), title('Contoured shelves');
    end
    
    for k = 1:length(s)

        theta = pi*s(k).Orientation/180;
        width=s(k).BoundingBox(3);
        height=s(k).BoundingBox(4);

        if(abs(s(k).Orientation) > 30 |  (height > 0.4*width) | height < 20)
            shelves_labeledXored = bitxor(shelves_labeled,k);
            shelves_labeled(shelves_labeledXored == 0) = 0;
            continue;         
        end

        avgHeightIterations = avgHeightIterations+1;
        avgHeight = avgHeight*(avgHeightIterations-1)/avgHeightIterations + s(k).MinorAxisLength /avgHeightIterations ;

        %elipse
        xbar = s(k).Centroid(1);
        ybar = s(k).Centroid(2);

        a = s(k).MajorAxisLength/2;
        b = s(k).MinorAxisLength/2;

        R = [ cos(theta)   sin(theta)
             -sin(theta)   cos(theta)];

        xy = [a*cosphi; b*sinphi];
        xy = R*xy;

        xy(1,:) = xy(1,:) + xbar;
        xy(2,:) = xy(2,:) + ybar;
        
        ellipse = xy;

        

        %rectangle('Position', [x y w h])
        w=s(k).BoundingBox(3); %w=s(k).MajorAxisLength; %width
        h=s(k).MinorAxisLength; %height
        x=-w/2;
        y=-h/2; %corner position
        xv=[x x+w x+w x x];
        yv=[y y y+h y+h y];
        %hold on; plot(xv,yv);

        %rotate angle alpha
        Rrect(1,:)=xv;Rrect(2,:)=yv;
        XY=R*Rrect;

        deltaX = 0;
        deltaY = 0;
        if (w/2 > xbar)
            deltaX = w/2 - xbar;
            deltaY = deltaX * sin(theta);
        end

        XY(1,:) = XY(1,:) + xbar + deltaX;
        XY(2,:) = XY(2,:) + ybar - deltaY;
        
        rectangle = XY;

        xv=[-size(shelfObject.shelves,2) size(shelfObject.shelves,2)];
        yv=[0 0];
        %rotate angle alpha
        Rline(1,:)=xv;Rline(2,:)=yv;
        XY=R*Rline;
        if (w/2 > xbar)
            deltaX = w/2 - xbar;
            deltaY = deltaX * sin(theta);
        end
        XY(1,:) = XY(1,:) + xbar + deltaX;
        XY(2,:) = XY(2,:) + ybar - deltaY;
        bar(k).x = XY(1,:);
        bar(k).y = XY(2,:);
        
        if(bDebug)
            figure(99) ;      
            hold on;plot(bar(k).x,bar(k).y,'blue','LineWidth',3);    
            hold on;plot(ellipse(1,:),ellipse(2,:),'red','LineWidth',2);
            %hold on;plot(rectangle(1,:),rectangle(2,:),'yellow','LineWidth',2);
        end
        
        %lineX = [0 size(shelf,2)];
        %deg = theta;
        %lineY = tan(deg).*lineX -tan(deg).*xbar + ybar;
        %hold on; line(lineX,lineY);
        shelfDetail = [shelfDetail; int32([xbar ybar width height s(k).Orientation 0])];
        shelfDetails.shelfDetail = shelfDetail;

    end
    
    [shelfDetails.shelfGapPixels shelfDetails.shelfDetail] = ShelfGapInPixels( shelfDetail ,shelfObject.shelves);

    if(bDebug)
        indx = find(shelfDetails.shelfDetail(:,6) == true);
        rand = transpose(random('Normal',0,double(size(shelfObject.shelves,2)*0.1),1,size(shelfDetails.shelfDetail(:,6),1)));
        xBar = mod([shelfDetails.shelfDetail(indx,1) shelfDetails.shelfDetail(indx,1)]+int32([rand(indx) rand(indx)]),size(shelfObject.shelves,2))  ;
        yBar = [shelfDetails.shelfDetail(indx,2) shelfDetails.shelfDetail(indx,2)+shelfDetails.shelfGapPixels];

        figure(99) ;  
        for ii=1:size(xBar,1)
            plot(xBar(ii,:),yBar(ii,:),'yellow','LineWidth',5);
        end 
    end
    
    hold off;
    %figure(999),imshow(shelves_labeled);

   
    
    if(~bCalculateEmptySpace)
        return;
    end
    
    %%
    wholeSegmentedShelf = shelfObject.shelvesSegmented;
    %figure(1337),imshow(wholeSegmentedShelf);
    se1 = strel('rectangle', [2 10]);
    I_opened = imerode(wholeSegmentedShelf,se1);
    se2 = strel('disk',2);
    I_opened = imerode(I_opened,strel('rectangle', [2 2]));
    I_opened = imdilate(I_opened,se2);
    %figure(1338),imshow(I_opened);
    I_opened = imclose(I_opened,se1);

    %figure(1338),imshow(I_opened);
    sizeOfBannedBlobs = floor(size(wholeSegmentedShelf,1)*size(wholeSegmentedShelf,2)*0.002);
    wholeSegmentedShelf_morph = bwareaopen(I_opened, sizeOfBannedBlobs);
    wholeSegmentedShelf_labeled = bwlabel(wholeSegmentedShelf_morph, 4);
    wholeSegmentedShelf_labeled = imfill(wholeSegmentedShelf_labeled);
    if(bDebug)
        figure(1),subplot(2,3,6);imshow(wholeSegmentedShelf_labeled);title({'empty place after';' basic operations'});
    end

    %%

    wholeS = regionprops(wholeSegmentedShelf_labeled, 'Orientation', 'MajorAxisLength', ...
        'MinorAxisLength', 'Eccentricity', 'Centroid' , 'BoundingBox');

    for k = 1:length(wholeS)
        %figure,imshow(shelves_labeled);
        specific_shelf = not(bitxor(wholeSegmentedShelf_labeled,k));
        %figure,imshow(specific_shelf);
        specific_shelf_Compared = bitand(specific_shelf,shelves_labeled > 0);
        %figure,imshow(specific_shelf_Compared);
        overlapSize = sum(sum(specific_shelf_Compared));
        if(overlapSize > sizeOfBannedBlobs)
            line = zeros(size(specific_shelf_Compared));
            index = max(max(shelves_labeled(specific_shelf_Compared > 0)));

            [myline,mycoords,outmat,X,Y] = bresenham(specific_shelf_Compared,[1,bar(index).y(1);size(specific_shelf_Compared,2),bar(index).y(2)],0);

            se2 = strel('disk',4);
            outmat = imdilate(outmat,se2);
            outmat = imfill(outmat,'holes'); % there might be holes due to crossing line

            [specific_shelf_Compared_labeled numberOfBlobsExceptShelf] = bwlabel(not(outmat), 4);

            [n m]= find(specific_shelf_Compared_labeled ~= 2);
            if(size(n,1) > size(specific_shelf_Compared_labeled,1)*size(specific_shelf_Compared_labeled,2)*0.95)
                specific_shelf_Compared_labeled_only_over = specific_shelf_Compared;
            else
                specific_shelf_Compared_labeled_only_over = bitxor(specific_shelf_Compared_labeled,2); 
            end

            %specific_shelf_Compared_labeled_only_over = specific_shelf_Compared;
            %if(numberOfBlobsExceptShelf == 2) %its being divided exactly to under and over the shelf

                %figure,imshow(specific_shelf_Compared_labeled_only_over);
            %end
            emptySpace = bitxor(specific_shelf,specific_shelf_Compared);
            emptySpace = bitand(specific_shelf_Compared_labeled_only_over,emptySpace);
            %figure,imshow(emptySpace);

            %BWoutline = bwperim(emptySpace);
            [r,c]= find(emptySpace > 0);
            if(bDebug)
                figure(99);hold on;plot(c,r,'green');
            end

            se2 = strel('line',avgHeight*0.4,90);
            treshEmptySpace = imopen(emptySpace,se2);
            %BWoutline = bwperim(treshEmptySpace);
            [r,c]= find(treshEmptySpace > 0);
            if(bDebug)
                figure(99);hold on;plot(c,r,'red');
            end



        end


         %   shelves_labeled(shelves_labeledXored == 0) = 0;

    end
    hold off



end
