 %%
  numberOfExamples = 3000;
  
% Show both images
  I = zeros([max(size(I1,1),size(I2,1)) size(I1,2)+size(I2,2) size(I1,3)]); %horizontal
  I(1:size(I1,1),1:size(I1,2),:)=I1;
  I(1:size(I2,1),size(I1,2)+1:size(I1,2)+size(I2,2),:)=I2;
  figure(1), imshow(I/255); hold on;
  


  
% Show the best matches
  for i=1:numberOfExamples,
      c=rand(1,3);
      plot([Ipts1(cor1(i)).x Ipts2(cor2(i)).x+size(I1,2)],[Ipts1(cor1(i)).y Ipts2(cor2(i)).y],'-','Color',c)
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