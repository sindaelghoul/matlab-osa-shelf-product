function [ shelfGapPixels , shelves_details ] = ShelfGapInPixels( shelves_details ,shelves)
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
    retun; %prompt for error if less than 3 shelves are present
end

[yC yI] = sort(shelves_details(yIndxs,2));

yMatrix = zeros(size(yC,1)+1,2);
yMatrix([1:end-1],1) = yC;
yMatrix([2:end],2) = yC;

yDiff = yMatrix(:,1)-yMatrix(:,2);
yDiff = yDiff(2:end-1,:);
bins = linspace(0,size(shelves,1),10);
[inds,xout] = hist(yDiff,bins);
[yC yI]  = sort(inds(1,:));  %% get the commonest y

common = int32(xout(yI(end)));
distFromCommon = single((abs(int32(yDiff)-repmat(common,size(yDiff,1),1))))/single(size(shelves,1))
indxEnd = find(distFromCommon < 0.1);% we want only those who fall with in the -5%..+5%

[0 ;yDiff(indxEnd) ;0]
shelfGapPixels = mean(yDiff(indxEnd));

end

