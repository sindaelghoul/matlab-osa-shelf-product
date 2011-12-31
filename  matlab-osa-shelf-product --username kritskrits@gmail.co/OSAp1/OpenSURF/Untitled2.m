%function [ output_args ] = ReadSURFDescriptors( Image , Options )
    [s, w] = dos('set NUMBER_OF_PROCESSORS');
    num_CPUs = sscanf(w, '%*21c%d', [1, Inf]);
    Image=imread('pics/shelf40.jpg');
    [nR, nC] = size(Image);
    % Get the Key Points
    Options.upright=true;
    Options.tresh=0.0001;
    
    num_CPUs = 2;
    
    overallTime = tic;
    totalSize = 0;
    matrixPart = ceil(nR/num_CPUs);
    for i=1:num_CPUs
        pts = OpenSurf(Image((1 + matrixPart*(i-1)):min((matrixPart*i),nR),:,:),Options);
        %offset = repmat(matrixPart*(i-1),[1 size(pts,2)]);
        %[pts(1,:).x] = [pts(1,:).x] + offset(1,:);
        Ipts(i).pts = pts;
        totalSize = totalSize + size(pts,2);
    end
    
    disp(['SURF process took ' num2str(toc(overallTime)) 'seconds']);
    
    ImageBitMap = zeros(size(Image,1),size(Image,2));
    %for i=1:


%end

