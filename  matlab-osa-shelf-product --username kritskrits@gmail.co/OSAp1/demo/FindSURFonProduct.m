function [ productIndex ] = FindSURFonProduct( productIndex )

    global SurfProductOptions;
    global num_CPUs;
    options = SurfProductOptions;
    
    totalSize = 0;
    jobsPerCpu = 1;
    jobsCount = min(productIndex.Length,num_CPUs);
    
    if(jobsCount < productIndex.Length) %if there are less CPUs than Products
        jobsPerCpu = ceil(productIndex.Length / jobsCount);
    end
    
    overallTime = tic;
    parfor i=1:jobsCount
        for j=1:jobsPerCpu
            index = i;
            if(jobsCount < productIndex.Length)
                index = (i-1)*jobsPerCpu+j;
            end
            if(index <= productIndex.Length)
                disp(['SURF process on product index (proccessor ' num2str(i) ')' num2str(index)]);
                [rect product] = ProductGetByIndex(productIndex,index,[]);
                pts(i).pts(j).pts = OpenSurf(product,options);
                pts(i).pts(j).index = index;
            end
        end
    end
    disp(['overall products ' num2str(productIndex.Length) ' SURF process took ' num2str(toc(overallTime)) 'seconds']);
    

    for i=1:size(pts,2)
        for j=1:size(pts(1,i).pts,2)
            index = pts(i).pts(j).index;
            points = pts(i).pts(j).pts;
            [productIndex.Products(index).rect productIndex.Products(index).product] = ProductGetByIndex(productIndex,index,[]); 
            ImageBitMap = uint16(zeros(size(productIndex.Products(index).product,1),size(productIndex.Products(index).product,2)));
            
            for ii=1:size(points,2)
                x = round(points(ii).x);
                y = round(points(ii).y);
                ImageBitMap(y,x) = ii;
            end
            
            productIndex.SURF.Products(index).pts = points;
            productIndex.SURF.Products(index).bitmap = ImageBitMap;
        end
    end
    
end


