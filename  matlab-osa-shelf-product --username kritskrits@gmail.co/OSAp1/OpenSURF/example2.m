% Example 2, Corresponding points
% Load images
close all;
  I1=imread('TestImages/shelf40.jpg');
  I2=imread('TestImages/1product.jpg');
% Get the Key Points
  Options.upright=true;
  Options.tresh=0.0001;
  %if(isempty(Ipts1))
      overallTime = tic;
      Ipts1=OpenSurf(I1,Options);
      disp(['shelf SURF process took ' num2str(toc(overallTime)) 'seconds']);
  %end
  overallTime = tic;
  Ipts2=OpenSurf(I2,Options);
  disp(['product SURF process took ' num2str(toc(overallTime)) 'seconds']);
% Put the landmark descriptors in a matrix
  D1 = reshape([Ipts1.descriptor],64,[]); 
  D2 = reshape([Ipts2.descriptor],64,[]); 
% Find the best matches
length(Ipts1)
length(Ipts2)
  err=zeros(1,length(Ipts1));
  cor1=1:length(Ipts1); 
  cor2=zeros(1,length(Ipts1));
  for i=1:length(Ipts1),
      distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);
      [err(i),cor2(i)]=min(distance);
  end
% Sort matches on vector distance
  [err, ind]=sort(err); 
  cor1=cor1(ind); 
  cor2=cor2(ind);
  
  %%
  numberOfExamples = 300;
  
% Show both images
  I = zeros([max(size(I1,1),size(I2,1)) size(I1,2)+size(I2,2) size(I1,3)]); %horizontal
  I(1:size(I1,1),1:size(I1,2),:)=I1;
  I(1:size(I2,1),size(I1,2)+1:size(I1,2)+size(I2,2),:)=I2;
  figure(1), imshow(I/255); hold on;
  


  
% Show the best matches
  for i=1:numberOfExamples,
      c=rand(1,3);
      %plot([Ipts1(cor1(i)).x Ipts2(cor2(i)).x+size(I1,2)],[Ipts1(cor1(i)).y Ipts2(cor2(i)).y],'-','Color',c)
      plot([Ipts1(cor1(i)).x Ipts2(cor2(i)).x+size(I1,2)],[Ipts1(cor1(i)).y Ipts2(cor2(i)).y],'o','Color',c)
  end
  
    % Show both images
  I = zeros([size(I1,1)+size(I2,1) max(size(I1,2),size(I2,2)) size(I1,3)]); %vertical
  I(1:size(I1,1),1:size(I1,2),:)=I1;
  I(size(I1,1)+1:size(I1,1)+size(I2,1),1:size(I2,2),:)=I2;
  figure(2), imshow(I/255); hold on;
  
  % Show the best matches
  for i=1:numberOfExamples,
      c=rand(1,3);
      plot([Ipts1(cor1(i)).x Ipts2(cor2(i)).x],[Ipts1(cor1(i)).y Ipts2(cor2(i)).y+size(I1,1)],'-','Color',c)
      plot([Ipts1(cor1(i)).x Ipts2(cor2(i)).x],[Ipts1(cor1(i)).y Ipts2(cor2(i)).y+size(I1,1)],'o','Color',c)
  end