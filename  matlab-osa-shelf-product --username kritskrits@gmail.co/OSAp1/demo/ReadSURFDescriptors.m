function [ ImageBitMap , pts ] = ReadSURFDescriptors( Image )
    global SurfShelfOptions;
    surfProcess = tic;
    pts = OpenSurf(Image,SurfShelfOptions);
    disp(['SURF process took ' num2str(toc(surfProcess)) 'seconds']);

    ImageBitMap = uint16(zeros(size(Image,1),size(Image,2)));
    
    for i=1:size(pts,2)
        x = round(pts(i).x);
        y = round(pts(i).y);
        ImageBitMap(y,x) = i;
    end



end

