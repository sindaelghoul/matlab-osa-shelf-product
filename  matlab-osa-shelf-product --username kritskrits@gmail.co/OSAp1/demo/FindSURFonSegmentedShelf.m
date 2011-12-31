function [ shelves_details ] = FindSURFonSegmentedShelf( shelves_details )
    segmented = uint8(~shelves_details.sigmentedShelves)*255;
    sigmentedShelvesAsColored = repmat(segmented,[1 1 3]);
    shelvesMasked = bitand(shelves_details.shelfObject.shelves,sigmentedShelvesAsColored);
    
    disp(['Going to perform SURF process , will take awhile...']);
    [ ImageBitMap , pts ] = ReadSURFDescriptors( shelvesMasked );
    
     sigmentedBitmap = uint16(~shelves_details.sigmentedShelves)*65535;
       
    se = strel('disk',4);
    I_opened = imerode(sigmentedBitmap,se);
    ImageBitMap = bitand(ImageBitMap,I_opened);
    
    shelves_details.SURF.pts = pts;
    shelves_details.SURF.bitmap = ImageBitMap;

end

