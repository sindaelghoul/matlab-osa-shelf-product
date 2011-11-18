%%
%shelves_details =shelves_details.shelfDetail;
%%
close all;
shelfXandWidth = zeros(size(shelves_details,1),3);
shelfXandWidth(:,1:2) = shelves_details(:,[1 3]);

bins = linspace(0,size(shelves,2),10);

[inds,xout] = hist(double(shelfXandWidth(:,1:2)),bins);
[wC wI]  = sort(inds(:,2));  %% get the commonest width
[xC xI]  = sort(inds(:,1));

common = int32([xout(xI(end-1)) xout(xI(end)) xout(wI(end))]);
distFromCommon = single((abs(int32(shelfXandWidth(:,[1 1 2]))-repmat(common,size(shelves_details,1),1))))/single(size(shelves,2))
indxEnd = find(distFromCommon(:,2) < 0.1 & distFromCommon(:,3) < 0.1);% we want only those who fall with in the -5%..+5%
indxPreEnd = find(distFromCommon(:,1) < 0.1 & distFromCommon(:,3) < 0.1);% we want only those who fall with in the -5%..+5%

if(size(indxEnd,1) > size(indxPreEnd,1))
    yIndxs = indxEnd;
else
    yIndxs = indxPreEnd;
end

if(size(yIndxs,1) < 3)
    shelfGapPixels = -1; %prompt for error if less than 3 shelves are present
end

[yC yI] = sort(shelves_details(yIndxs,2));

yMatrix = zeros(size(yC,1)+1,2);
yMatrix([1:end-1],1) = yC;
yMatrix([2:end],2) = yC;

yDiff = yMatrix(:,1)-yMatrix(:,2);
yDiff = yDiff(2:end-1,:);
bins = linspace(0,size(shelves,1),10);
[inds,xout] = hist(yDiff,bins);
[yC yIi]  = sort(inds(1,:));  %% get the commonest y

common = int32(xout(yIi(end)));
distFromCommon = single((abs(int32(yDiff)-repmat(common,size(yDiff,1),1))))/single(size(shelves,1))
indxEnd = find(distFromCommon < 0.1);% we want only those who fall with in the -5%..+5%

%indexOffset = indxEnd + 1;
shelfGapPixels = mean(yDiff(indxEnd));

indexOffset = zeros(size(yMatrix,1),1);
indexOffset(1+indxEnd,:) =true;

shelfDetail = shelves_details;
indx = find(shelfDetail(:,6) == true);
rand = transpose(random('Normal',0,double(size(shelves,2)*0.1),1,size(shelfDetail(:,6),1)))

[shelfDetail(indx,1) shelfDetail(indx,1)]
[rand(indx) rand(indx)]
xBar = mod([shelfDetail(indx,1) shelfDetail(indx,1)]+int32([rand(indx) rand(indx)]),size(shelves,2))  ;
yBar = [shelfDetail(indx,2) shelfDetail(indx,2)+shelfGapPixels];

figure(1);
imshow(shelves);
hold on;
for ii=1:size(xBar,1);
    plot(xBar(ii,:),yBar(ii,:),'blue','LineWidth',3);
end

%%

objects = sh(:,3)
len = size(sh(:,3))
summedDist = zeros(len,1)

for ii = 1:len
  inds = true(len,1);
  inds(ii) = false;
  comparedObjs = objects(inds,:); %is the data with one left out
  obj = objects(~inds,:); % is the one that was left out
  
  dist = dist(comparedObjs,obj)
  summedDist = summedDist + dist
end 

I = crossvalind('Kfold', sh(:,3));

a=sort(sh(:,3));
figure(1);
histc(double(sh(:,3)),[74 436 1935]);

randsample(double(sh(:,3)),size(sh(:,3),1));

%%
X = sh(:,1);
%X =rand(100,5);
Y = pdist(X,'cityblock');
Z = linkage(Y,'average');
[H,T] = dendrogram(Z,'colorthreshold','default');
set(H,'LineWidth',2)

find(T==20)