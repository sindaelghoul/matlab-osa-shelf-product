function [ output_args ] = Contouring( input_args )
clear all;clc;clear all;
%% read matching data from file
fid = fopen('matchings.txt');

%read number of matches
matches = cell2mat(textscan(fid, '%d',1));
% read numeric data
C_data = textscan(fid, '%d %d %d %d',1);
for k = 1 : matches - 1
    C_data = [C_data;textscan(fid, '%d %d %d %d',1)];
end

C_data.original = cell2mat(C_data);

fclose(fid);

%%
figure(1);
plot(C_data(:,3), C_data(:,4), 'black*','MarkerSize',10); %out of product bounds
hold on
plot(C_data(:,1), C_data(:,2), 'blue*','MarkerSize',10); %out of product bounds

%% wipeout the missed matches
[C_data.sortData, C_data.originalIndexOfSorted] = sort(C_data.original);
C_data.std = std(double(C_data.original));
C_data.mean = mean(double(C_data.original));
C_data.diffX = find(C_data.originalIndexOfSorted(:,1)~=C_data.originalIndexOfSorted(:,3));
C_data.diffY = find(C_data.originalIndexOfSorted(:,2)~=C_data.originalIndexOfSorted(:,4));

bRecalc = false;
if(~isempty(C_data.diffX))
    xTagNorm = double(abs(C_data.original(C_data.diffX(1:end),3)-C_data.mean(3)))/C_data.std(3)
    xNorm = double(abs(C_data.original(C_data.diffX(1:end),1)-C_data.mean(1)))/C_data.std(1)
    xMaxNorm = max(xTagNorm(1:end),xNorm(1:end))
    xMinNorm = min(xTagNorm(1:end),xNorm(1:end))
    
    for k=1:length(C_data.diffX)
        if( xMinNorm(k) / xMaxNorm(k) < 0.9 )
           xMinNorm(k) / xMaxNorm(k)
           C_data.original(C_data.diffX(k),(1:end)) = 0;
           bRecalc = true;
        end
    end
end

if(~isempty(C_data.diffY))
    yTagNorm = double(abs(C_data.original(C_data.diffY(1:end),4)-C_data.mean(4)))/C_data.std(4)
    yNorm = double(abs(C_data.original(C_data.diffY(1:end),2)-C_data.mean(2)))/C_data.std(2)
    yMaxNorm = max(yTagNorm(1:end),yNorm(1:end))
    yMinNorm = min(yTagNorm(1:end),yNorm(1:end))
    
    for k=1:length(C_data.diffY)
        if( yMinNorm(k) / yMaxNorm(k) < 0.9 )
           yMinNorm(k) / yMaxNorm(k)
           C_data.original(C_data.diffY(k),(1:end)) = 0;
           Recalc = true;
        end
    end
end

% calc mean and std once again with the right values
C_data.var = var(double(C_data.original));
if(bRecalc)
    C_data.std = std(double(C_data.original));
    C_data.mean = mean(double(C_data.original));
end

%% contour the findings
pImage = imread('Names.jpg');
ptImage = imread('shelf_namess05.jpg');

% borders of cluster
% pLeft = min(C_data.sortData(find(C_data.sortData(:,1) > 0),1));
% pUpper = min(C_data.sortData(find(C_data.sortData(:,2) > 0),2));
% pRight = max(C_data.sortData(find(C_data.sortData(:,1) > 0),1));
% pBottom = max(C_data.sortData(find(C_data.sortData(:,2) > 0),2));
% 
% ptLeft = min(C_data.sortData(find(C_data.sortData(:,3) > 0),3));
% ptUpper = min(C_data.sortData(find(C_data.sortData(:,4) > 0),4));
% ptRight = max(C_data.sortData(find(C_data.sortData(:,3) > 0),3));
% ptBottom = max(C_data.sortData(find(C_data.sortData(:,4) > 0),4));

C_data.varianceRatio = C_data.var(1:2)./C_data.var(3:4);
C_data.stdRatio = C_data.std(1:2)./C_data.std(3:4);

ratio = min(C_data.varianceRatio);
C_data.ptRectangleOffset.left = C_data.mean(1) * ratio;
C_data.ptRectangleOffset.right = (length(pImage(1,:,1)) - C_data.mean(1)) * ratio;
C_data.ptRectangleOffset.top = C_data.mean(2) * ratio;
C_data.ptRectangleOffset.bottom = (length(pImage(:,1,1)) - C_data.mean(2)) * ratio;

%% example of conturing
figure(1);
imshow(pImage);
hold on;
rectangle('Position',[C_data.mean(1) - pLeft,...
                      C_data.mean(2) - pUpper,...
                      pLeft + pRight,...
                      pUpper + pBottom]);

%% example of conturing
figure(1);
imshow(ptImage);
hold on;
plot(C_data.mean(3),C_data.mean(4));
rectangle('Position',[C_data.mean(3) - C_data.ptRectangleOffset.left,...
                      C_data.mean(4) - C_data.ptRectangleOffset.top,...
                      C_data.ptRectangleOffset.left + C_data.ptRectangleOffset.right,...
                      C_data.ptRectangleOffset.top + C_data.ptRectangleOffset.bottom]);

%%
[sortDataX, IX] = sort(C_data(:,1));
[sortDataY, IY] = sort(C_data(:,2));
[sortDataXt, IXt] = sort(C_data(:,3));
[sortDataYt, IYt] = sort(C_data(:,4));

var(double(sortDataX))
var(double(sortDataY))
var(double(sortDataXt))
var(double(sortDataYt))

diffX = find(IX~=IXt);

%% create contoured data from product views
sort
pdist

%clear all;clc;close all;
product = imread('coffee_namess.jpg');
%figure(1), imshow(product), title('product');


bw = im2bw(product,0.9);
%figure(2), imshow(bw), title('product bw');

se = strel('rectangle', [5 5]);
I_closed = imclose(bw,se);
se = strel('rectangle', [15 15]);
I_opened = imopen(I_closed,se);
I_opened = ~I_opened;
BWdfill = imfill(I_opened, 'holes');
%figure(3), imshow(BWdfill), title('product after morphological close/open');

productViewsLabled = bwlabel(BWdfill,4);


s = regionprops(BWdfill, 'Centroid');
colorSpace = char('blue','green','red','cyan','magenta','yellow','black');
figure(4), imshow(product), title('product with Centroid Locations');
hold on
numObj = numel(s);
%indexing the product views
for k = 1 : numObj
    %plot(s(k).Centroid(1), s(k).Centroid(2), 'b*');
    text(s(k).Centroid(1),s(k).Centroid(2),sprintf('%d', k),'FontSize', 25 ,'FontWeight','bold','BackgroundColor',[.7 .9 .7],'Color', colorSpace(k,:));
end

%painting the matched ASIFT cordinates
for k = 1 : matches
    if (productViewsLabled(C_data(k,2), C_data(k,1)) > 0)
        %plot(C_data(k,1), C_data(k,2), strcat(colorSpace(productViewsLabled(C_data(k,2), C_data(k,1)),:),'*')); 
        C_data(k,5) = 1;
    else
        %plot(C_data(k,1), C_data(k,2), 'black*','MarkerSize',30);
        C_data(k,5) = 0;
    end
end
hold off
 

%% shelf compare
shelf = imread('mySt.JPG');

cform = makecform('srgb2lab');
shelfCIELAB = applycform(shelf,cform);
productCIELAB = applycform(product,cform);

figure(5), imshow(shelf), title('shelf with matched ASIFT cordinates');
hold on
%painting the matched ASIFT cordinates
for k = 1 : matches
    %if (productViewsLabled(C_data(k,4), C_data(k,3)) > 0)
    if (C_data(k,5) == 0)
        plot(C_data(k,3), C_data(k,4), 'black*','MarkerSize',10); %out of product bounds
    else
        
        rect_shelf = [C_data(k,3)-3 C_data(k,4)-3 7 7];
        rect_prod = [C_data(k,1)-3 C_data(k,2)-3 7 7];
        
        sub_shelf = imcrop(shelfCIELAB,rect_shelf);
        sub_prod = imcrop(productCIELAB,rect_prod);
        
        if(isempty(sub_shelf))
            continue;
        end
        
        lS = mean2(sub_shelf(:,:,1));
        aS = mean2(sub_shelf(:,:,2));
        bS = mean2(sub_shelf(:,:,3));

        lP = mean2(sub_prod(:,:,1));
        aP = mean2(sub_prod(:,:,2));
        bP = mean2(sub_prod(:,:,3));

        %aDbS = aS/bS;
        lDaS = lS/aS;
        %lDbS = lS/bS;
        %aDbP = aP/bP;
        lDaP = lP/aP;
        %lDbP = lP/bP;
        
        aAbS = abs(aS-bS);
        %lAaS = abs(lS-aS);
        %lAbS = abs(lS-bS);
        aAbP = abs(aP-bP);
        %lAaP = abs(lP-aP);
        %lAbP = abs(lP-bP);
        
        ratioAbsDiff = min(aAbS,aAbP) / max(aAbS,aAbP);
        ratioDiv = min(lDaS,lDaP) / max(lDaS,lDaP);
        ratioL = min(lS,lP) / max(lS,lP);
  
        

        if (ratioL < 0.4 | ratioAbsDiff < 0.35 | ratioDiv < 0.55)
            %plot(C_data(k,1), C_data(k,2), '--rs','MarkerSize',30);
        else
            plot(C_data(k,3), C_data(k,4), strcat(colorSpace(productViewsLabled(C_data(k,2), C_data(k,1)),:),'*'),'MarkerSize',20);
        end
    end
end
hold off

end

