%%
close all;
shelfWidth = shelves_details(:,3);


[inds,xout] = hist(double(shelfWidth));
[C I]  = sort(inds);

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