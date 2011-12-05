%function [ output_args ] = Contouring( input_args )
clear all; clc; close all;
load('matlab4838.mat','-mat','productIndex','colorPlate','ii','matchPoints','routeIndex');
figure(888);
subplot(2,4,[3 4 7 8]);
imshow(routeIndex.shelves);

diffTresh = 33; 


for i=1:ii %product angle resolution
    dotColor = colorPlate(randi(100),:);
    ind = find(matchPoints(:,1)==i);
    %positions = zeros(size(ind,1),2);
    %productPositions = [matchPoints(ind,2)+matchPoints(ind,8) matchPoints(ind,3)+matchPoints(ind,9)];
    productPositions = [matchPoints(ind,2) matchPoints(ind,3) matchPoints(ind,8) matchPoints(ind,9) matchPoints(ind,6) matchPoints(ind,7)];
    try
        delete(g);
    catch exp
    end
    j=1;
    while (j < size(productPositions,1)) %object on shelf resolution
        C_data = [];
        matchInds = find((productPositions(:,1) == productPositions(j,1)) & (productPositions(:,2) == productPositions(j,2)));
        j=j+size(matchInds,1); %advance in j , substructing 1
        positions = productPositions(matchInds,:);
        %positions = positions*routeIndex.ImagesRatio;
        %figure(8);
        %hold on;
        %plot(positions(:,1),positions(:,2), '*' , 'color' , dotColor , 'MarkerSize',5*(ii-(i-1)));


        %%
        %figure(1);
        %plot(C_data(:,3), C_data(:,4), 'black*','MarkerSize',10); %out of product bounds
        %hold on
        %plot(C_data(:,1), C_data(:,2), 'blue*','MarkerSize',10); %out of product bounds
        
        % product(1,2) shelf(3,4)
        C_data.original = [matchPoints(matchInds,6) matchPoints(matchInds,7) matchPoints(matchInds,8) matchPoints(matchInds,9)];
        C_data.data = double(C_data.original);
        dataHeight = size(C_data.data,1);
        %% wipeout the missed matches
        [C_data.sortData, C_data.originalIndexOfSorted] = sort(C_data.original);
        C_data.std = std(double(C_data.original));
        C_data.mean = mean(double(C_data.original));
        
        
%         C_data.diffX = find(C_data.originalIndexOfSorted(:,1)~=C_data.originalIndexOfSorted(:,3));
%         C_data.diffY = find(C_data.originalIndexOfSorted(:,2)~=C_data.originalIndexOfSorted(:,4));
% 
%         bRecalc = false;
%         if(~isempty(C_data.diffX))
%             xTagNorm = double(C_data.original(C_data.diffX(1:end),3)-C_data.mean(3))/C_data.std(3)
%             xNorm = double(C_data.original(C_data.diffX(1:end),1)-C_data.mean(1))/C_data.std(1)
%             xMaxNorm = max(xTagNorm(1:end),xNorm(1:end));
%             xMinNorm = min(xTagNorm(1:end),xNorm(1:end));
% 
%             xx = xMinNorm ./ xMaxNorm;
%             xxInds = find ( xx < minDiff | xx > maxDiff);
%             C_data.original(C_data.diffX(xxInds),(1:end)) = 0;
%             
%             if(~isempty(xxInds))
%                 bRecalc = true;
%             end
%             
%         end
% 
%         if(~isempty(C_data.diffY))
%             yTagNorm = double(C_data.original(C_data.diffY(1:end),4)-C_data.mean(4))/C_data.std(4)
%             yNorm = double(C_data.original(C_data.diffY(1:end),2)-C_data.mean(2))/C_data.std(2)
%             yMaxNorm = max(yTagNorm(1:end),yNorm(1:end));
%             yMinNorm = min(yTagNorm(1:end),yNorm(1:end));
% 
%             yy = yMinNorm ./ yMaxNorm;
%             yyInds = find ( yy < minDiff | yy > maxDiff);
%             C_data.original(C_data.diffY(yyInds),(1:end)) = 0;
%             
%             if(~isempty(yyInds))
%                 bRecalc = true;
%             end
%             
%         end

%         dotInds = find(C_data.original(:,1) ~= 0);
        
        %ploting the matched points on shelf (unfiltered)
        figure(888);
        subplot(2,4,[3 4 7 8]);
        hold on;
        plot(positions(1,1)+positions(:,3),positions(1,2)+positions(:,4), 'white*' , 'MarkerSize',5); 
        %hold on;
        %plot(positions(dotInds,1)+positions(dotInds,3),positions(dotInds,2)+positions(dotInds,4), '*' , 'color' , dotColor , 'MarkerSize',5); 
        
        
        % calc mean and std once again with the right values
%         C_data.var = var(double(C_data.original(dotInds,:)))
        meanForFigure = C_data.mean ;
%         if(bRecalc && size(dotInds,2) > 1)
%             C_data.std = std(double(C_data.original(dotInds,:)))
%             C_data.mean = mean(double(C_data.original(dotInds,:)))
%         end

        %% contour the findings
        %pImage = imread('Names.jpg');
        [rect_prod pImage] = ProductGetByIndex(productIndex,i,[]);
        try
        delete(h1);
        delete(h2);
        catch exp
        end
        
        %ploting the matched points on product (unfiltered)
        figure(888);
        g = subplot(2,4,1);
        imshow(pImage);hold on;
        plot(C_data.data(:,1), C_data.data(:,2), 'white*', 'MarkerSize',5);
        
        %calculating the vector from each Matching point to center
        %(PRODUCT)
        for iLine = 1:dataHeight
            X = double([C_data.data(iLine,1) C_data.mean(1)]);
            Y = double([C_data.data(iLine,2) C_data.mean(2)]);
            
            line(X,Y);
            
            xx = X(2) - X(1);
            yy = Y(2) - Y(1);
            
            V = [xx yy];
            V1=V/norm(V);

            C_data.data(iLine,5:6) = V1;
        end
        
        
        h1 = subplot(2,4,5);
        rectX = max(positions(:,1)-1*meanForFigure(3),0); 
        rectY = max(positions(:,2)-1*meanForFigure(4),0);
        sub_shelf = imcrop(routeIndex.shelves,[rectX(1) rectY(1) 6*meanForFigure(3) 6*meanForFigure(4)] );
        imshow(sub_shelf);hold on;
        plot(meanForFigure(3)+positions(:,3),meanForFigure(4)+positions(:,4), 'white*' , 'MarkerSize',5); 

        hold on;
        
	
        maxMean = max(meanForFigure(3),meanForFigure(4)); %furthestLengh = double(((C_data.sortData(dataHeight,1) - C_data.sortData(1,1))^2 + (C_data.sortData(dataHeight,2) - C_data.sortData(1,2))^2))^0.5;

        numberOfIntersects = (dataHeight  - 1)*(dataHeight / 2);
        intersections = zeros(numberOfIntersects,5);
        lines = zeros(dataHeight,4);
        for iLine = 1:dataHeight
            x = meanForFigure(3)+positions(iLine,3);
            y = meanForFigure(4)+positions(iLine,4);
             
            X = double([x x+maxMean*C_data.data(iLine,5)]); %X = double([x x+furthestLengh*C_data.data(iLine,5)]);
            Y = double([y y+maxMean*C_data.data(iLine,6)]); %Y = double([y y+furthestLengh*C_data.data(iLine,6)]);
            
            line(X,Y);
            lines(iLine,:) = [X(1) Y(1) X(2) Y(2)]; 
        end
        
        %calculating the intersections of all vectors with each other
        iNd = 1;
        for line1Index = 1:dataHeight
            for line2Index = 1:line1Index
                if(line1Index ~= line2Index)
                    %look for intersection and plot intersection
                    [intxX,intxY]=lineintersect(lines(line1Index,:),lines(line2Index,:));
                    plot(intxX,intxY,'ro','MarkerFaceColor','g','LineWidth',2) %this will mark the intersection point with red 'o'
                    if(~isnan(intxX) && ~isnan(intxY))
                        intersections(iNd,:) = [intxX intxY line1Index line2Index 0];
                        iNd=iNd+1;
                    end
                end
            end
        end
        
        intersections = intersections((intersections(:,1) ~= 0 & intersections(:,2) ~= 0),:);
        
        if(size(intersections,1) < 3)
            continue;
        end
        
        meanInterSection = mean(intersections);
        
        
        plot(meanInterSection(1),meanInterSection(2),'bo','MarkerFaceColor','y','LineWidth',2) %this will mark the intersection point with red 'o'
                    
                  
        %calculating the vector from each Matching point to mean center of
        %intersections (ON SHELF)
        for iLine = 1:dataHeight
            xPoint = meanForFigure(3)+positions(iLine,3);
            yPoint = meanForFigure(4)+positions(iLine,4);
            
            X = double([xPoint meanInterSection(1)]);
            Y = double([yPoint meanInterSection(2)]);
            
            line(X,Y , 'Color' , 'red');
            
            xx = X(2) - X(1);
            yy = Y(2) - Y(1);
            
            V = [xx yy];
            V1=V/norm(V);

            C_data.data(iLine,7:8) = V1;
            
            [thetaShelf,~] = cart2pol(V1(1),V1(2));
            [thetaProduct,~] = cart2pol(C_data.data(iLine,5),C_data.data(iLine,6));
            
            C_data.data(iLine,9)=(abs(thetaShelf-thetaProduct))*180/pi;
        end
        
        matchInds = find(C_data.data(:,9) < diffTresh);
        size(matchInds,1)
        dataHeight
        
        intersections(:,5) = ismember(intersections(:,3),matchInds) & ismember(intersections(:,4),matchInds);

        
        % borders of cluster
%         pLeft = min(C_data.original(dotInds,1));
%         pUpper = min(C_data.original(dotInds,2));
%         pRight = max(C_data.original(dotInds,1));
%         pBottom = max(C_data.original(dotInds,2));
        % 
        % ptLeft = min(C_data.sortData(find(C_data.sortData(:,3) > 0),3));
        % ptUpper = min(C_data.sortData(find(C_data.sortData(:,4) > 0),4));
        % ptRight = max(C_data.sortData(find(C_data.sortData(:,3) > 0),3));
        % ptBottom = max(C_data.sortData(find(C_data.sortData(:,4) > 0),4));

%         C_data.varianceRatio = C_data.var(1:2)./C_data.var(3:4);
%         C_data.stdRatio = C_data.std(1:2)./C_data.std(3:4);

        %ratioX = C_data.stdRatio(1);
        %ratioY = C_data.stdRatio(2);
%         C_data.ptRectangleOffset.left = C_data.mean(1) * ratioX;
%         C_data.ptRectangleOffset.right = (length(pImage(1,:,1)) - C_data.mean(1)) * ratioX;
%         C_data.ptRectangleOffset.top = C_data.mean(2) * ratioY;
%         C_data.ptRectangleOffset.bottom = (length(pImage(:,1,1)) - C_data.mean(2)) * ratioY;

         C_data.ptRectangleOffset.left = C_data.mean(1);
         C_data.ptRectangleOffset.right = length(pImage(1,:,1)) - C_data.mean(1);
         C_data.ptRectangleOffset.top = C_data.mean(2);
         C_data.ptRectangleOffset.bottom = length(pImage(:,1,1)) - C_data.mean(2);


        %% example of conturing
        figure(888);
        subplot(2,4,1);
        hold on;
%         plot(C_data.original(dotInds,1),C_data.original(dotInds,2), '*' , 'color' , dotColor , 'MarkerSize',5);
%         hold on;
%         plot(C_data.mean(1),C_data.mean(2), '--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',10);
%        hold on;
        plot(C_data.mean(1),C_data.mean(2),'bo','MarkerFaceColor','y','LineWidth',2) %this will mark the intersection point with red 'o'
             
        figure(888);
        subplot(2,4,5);
        hold on;            
        plot(meanForFigure(3)+positions(matchInds,3),meanForFigure(4)+positions(matchInds,4), '*' , 'color' , dotColor , 'MarkerSize',5); 
        
        h2 = subplot(2,4,6);
        imshow(sub_shelf);hold on;
        plot(meanForFigure(3)+positions(:,3),meanForFigure(4)+positions(:,4), 'white*' ,'MarkerSize',5);
        plot(meanForFigure(3)+positions(matchInds,3),meanForFigure(4)+positions(matchInds,4), '*' , 'Color' , dotColor, 'MarkerSize',5); 
        plot(meanInterSection(1),meanInterSection(2),'bo','MarkerFaceColor','y','LineWidth',2) %this will mark the intersection point with red 'o'
        plot(meanForFigure(3) + C_data.mean(3),meanForFigure(4) + C_data.mean(4),'bo','MarkerFaceColor','r','LineWidth',2) %this will mark the intersection point with red 'o'

        figure(999);
        subplot(1,2,1);
        imshow(pImage);hold on;
        plot(C_data.data(:,1), C_data.data(:,2), 'white*', 'MarkerSize',5);
        plot(C_data.mean(1),C_data.mean(2),'bo','MarkerFaceColor','y','LineWidth',2) %this will mark the intersection point with red 'o'
             
        subplot(1,2,2);
        imshow(sub_shelf);hold on;
        plot(meanForFigure(3)+positions(:,3),meanForFigure(4)+positions(:,4), 'white*' ,'MarkerSize',5);
        plot(meanForFigure(3)+positions(matchInds,3),meanForFigure(4)+positions(matchInds,4), '*' , 'Color' , dotColor, 'MarkerSize',5); 
        plot(meanInterSection(1),meanInterSection(2),'bo','MarkerSize',10,'MarkerFaceColor','y','LineWidth',1) %this will mark the intersection point with red 'o'
        plot(meanForFigure(3) + C_data.mean(3),meanForFigure(4) + C_data.mean(4),'bo','MarkerFaceColor','r','LineWidth',1) %this will mark the intersection point with red 'o'

        
        rectangle('Position',[meanInterSection(1) - C_data.ptRectangleOffset.left,...
                              meanInterSection(2) - C_data.ptRectangleOffset.top,...
                              C_data.ptRectangleOffset.left + C_data.ptRectangleOffset.right,...
                              C_data.ptRectangleOffset.top + C_data.ptRectangleOffset.bottom]);
            
           
        %% example of conturing
        
%         figure(888);
%         subplot(2,4,[3 4 7 8]);
%         hold on;
%         plot(positions(1,1) + C_data.mean(3),positions(1,2) + C_data.mean(4), '--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',10);
%         rectangle('Position',[positions(1,1) + C_data.mean(3) - C_data.ptRectangleOffset.left,...
%                           positions(1,2) + C_data.mean(4) - C_data.ptRectangleOffset.top,...
%                           C_data.ptRectangleOffset.left + C_data.ptRectangleOffset.right,...
%                           C_data.ptRectangleOffset.top + C_data.ptRectangleOffset.bottom]);

    end
end

