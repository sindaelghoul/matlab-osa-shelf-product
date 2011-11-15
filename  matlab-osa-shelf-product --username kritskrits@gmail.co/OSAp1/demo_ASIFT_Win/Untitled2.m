%%
close all;
shelfXandWidth = zeros(size(shelves_details,1),3);
shelfXandWidth(:,1:2) = shelves_details(:,[1 3]);

bins = linspace(0,size(shelves,2),5);

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
    retun; %prompt for error if less than 3 shelves are present
end

shelves_details(yIndxs,2)

if(maxVal > 0.3*size(shelfWidth,2)) %number of largest same sized shelves must be above 30%
    
else
    
end
%int32(xout(

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