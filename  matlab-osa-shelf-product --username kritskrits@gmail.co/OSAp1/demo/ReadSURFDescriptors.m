%function [ output_args ] = ReadSURFDescriptors( Image , Options )
    [s, w] = dos('set NUMBER_OF_PROCESSORS');
    num_CPUs = sscanf(w, '%*21c%d', [1, Inf]);
    Image=imread('pics/shelf40.jpg');
    [nR, nC] = size(Image);
    % Get the Key Points
    Options.upright=true;
    Options.tresh=0.0001;
    
    overallTime = tic;
    matrixPart = ceil(nR/num_CPUs);
    for i=1:num_CPUs
        pts = OpenSurf(Image((1 + matrixPart*(i-1)):min((matrixPart*i),nR),:,:),Options);
        Ipts(i).pts = pts;
        Ipts(i).size = size(pts,2); 
    end
    
    disp(['SURF process took ' num2str(toc(overallTime)) 'seconds']);


%end

