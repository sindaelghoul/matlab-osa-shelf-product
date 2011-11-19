function [ shelfObject shelves ] = shelfDetectInit( shelves_FileLocation , shelfColor_FileLocation ,shelfEmptyColor_FileLocation,bDebug )
shelves = imread(shelves_FileLocation);

idx = regexp(shelves_FileLocation,'\d+');
nums = regexp(shelves_FileLocation,'\d+','match');
shelfObject.sizeInCM = str2num(nums{end});

%% shelf detection
    shelfExample = imread(shelfColor_FileLocation);

    cform = makecform('srgb2lab');
    shelfCIELAB = applycform(shelves,cform);
    shelfExampleCIELAB = applycform(shelfExample,cform);

    if(bDebug)
        figure(1);
        subplot(2,3,1);
        imshow(shelves), title('shelf');
    end


    lS = double(shelfCIELAB(:,:,1));
    aS = double(shelfCIELAB(:,:,2));
    bS = double(shelfCIELAB(:,:,3));

    lP = mean2(shelfExampleCIELAB(:,:,1));
    aP = mean2(shelfExampleCIELAB(:,:,2));
    bP = mean2(shelfExampleCIELAB(:,:,3));


    lDaS = lS./aS;

    lDaP = lP./aP;
    %lDbP = lP/bP;


    ratioDiv = lDaS ./ lDaP;
    ratioL = lS ./ lP;


    %Display Results of Nearest Neighbor Classification
    segmented = repmat(uint8(0),[size(lS)]);

    %segmented_images(distance < 1) = 255;
    absRatioL = abs(ratioL-1);
    absRatioDiv = abs(ratioDiv-1);
    %segmented_images(absRatioL < 0.02) = 255;
    segmented(ratioL > 1) = 255;

    if(bDebug)
        subplot(2,3,2);imshow(segmented);title({'Shelf detection';'before operations'});
    end
    
    shelfObject.segmented = segmented;
    shelfObject.shelfCIELAB = shelfCIELAB;
    shelfObject.shelfExampleCIELAB = shelfExampleCIELAB;
    shelfObject.shelves = shelves;
    shelfObject.shelvesSegmented = emptyShelf(shelfCIELAB,shelfEmptyColor_FileLocation,bDebug);
    
    
end

