
%%
figure(1);
X = [0 2];
Y = [0 2];
X2 = [0 9];
Y2 = [0 5];
x = X2 - X;
y = Y2 - Y;
line(X,Y);
hold on;
line(X2,Y2);
hold on;
line(x,y,'Color','g');

V = [x(2) y(2)];
V1=V/norm(V);
hold on;
line([0 V1(1)],[0 V1(2)] ,'Color','r');

%%
gg =(double(C_data.original(dotInds,:)) - double(repmat(C_data.mean,size(dotInds,1),1))) ./ double(repmat(C_data.std,size(dotInds,1),1))
gg(:,1)./gg(:,3)
gg(:,2)./gg(:,4)

xx = xMinNorm ./ xMaxNorm;
yy = yMinNorm ./ yMaxNorm;

find( xx > 0.9 & yy > 0.9)

%%

%This script tests the function "lineintersect.m" by Paulo Silva. Note
%that when line1=1 and line2=2, lineintersect.m finds the correct
%intersection BUT line1=2 ad line2=1 does not.


%4 equidistant points on perimeter of circle of radius 100. Placed at 45,
%135, 225, 315 degrees and converted to XY crds using pol2cart function. Row #1 is X-crds, Row #2 is Y-crds
ptsXY=[70.7106781186548,-70.7106781186547,-70.7106781186548;70.7106781186547,70.7106781186548,-70.7106781186547];

%plots points as red stars
hold on;
plot(ptsXY(1,:),ptsXY(2,:),'*','color','red');

%"Lines" describes how the points are connected. Here, pt 1 and pt 3 are connected. And pt 2 and pt 3 are connected.
Lines=[1,2;3,3];

%plot lines and label lines with line IDs
for ii=1:size(Lines,2)
    plot(ptsXY(1,Lines(:,ii)),ptsXY(2,Lines(:,ii)));
    text(linspace(ptsXY(1,Lines(1,ii)),ptsXY(1,Lines(2,ii)),10),linspace(ptsXY(2,Lines(1,ii)),ptsXY(2,Lines(2,ii)),10),int2str(ii),'Color','black','FontWeight','normal');
end

%choose two lines to test. Note that line1=1 and line2=2 finds the correct
%intersection BUT line1=2 ad line2=1 does not.
line1=2;
line2=1;

%extract XY crds
l1_XY=[ptsXY(:,Lines(1,line1)) ptsXY(:,Lines(2,line1))]; %-each line is defined by 4 coordinates: 2 X- and 2 Y-crds
l2_XY=[ptsXY(:,Lines(1,line2)) ptsXY(:,Lines(2,line2))]; %/

%look for intersection and plot intersection
[intxX,intxY]=lineintersect([l1_XY(:,1)' l1_XY(:,2)'],[l2_XY(:,1)' l2_XY(:,2)']);
plot(intxX,intxY,'ro','MarkerFaceColor','g','LineWidth',2) %this will mark the intersection point with red 'o'

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