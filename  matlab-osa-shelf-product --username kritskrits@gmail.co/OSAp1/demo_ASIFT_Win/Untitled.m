%%
subplot1(2,3);
subplot1(1); plot(rand(10,1));
subplot1(2); plot(rand(10,1)); 
%%
close all;
figure(6);
imshow(routeIndex.shelves);

figure(8);
imshow(shelves);
for i=1:ii
    dotColor = colorPlate(randi(100),:);
    ind = find(matchPoints(:,1)==i);
    %positions = zeros(size(ind,1),2);
    positions = [matchPoints(ind,2)+matchPoints(ind,8) matchPoints(ind,3)+matchPoints(ind,9)];
    figure(6);
    hold on;
    plot(positions(:,1),positions(:,2), '*' , 'color' , dotColor , 'MarkerSize',5*(ii-(i-1))); 
    
    positions = positions*routeIndex.ImagesRatio;
    figure(8);
    hold on;
    plot(positions(:,1),positions(:,2), '*' , 'color' , dotColor , 'MarkerSize',5*(ii-(i-1)));
end