%function [ output_args ] = Contouring( input_args )
clear all; clc; close all;
load('matlab4838.mat','-mat','trackingDebug','productIndex','colorPlate','ii','matchPoints','routeIndex');
%trackingDebug = double(trackingDebug);
figure(888);
subplot(2,4,[3 4 7 8]);
imshow(routeIndex.shelves);

diffAngleTresh = 33; %in deg to each direction
abortTresh = 0.4; %percentage
recalcTresh = 0.75; %percentage
numberOfIntersectsTresh = 1000;


trackingDebugIndex = 1;
for i=1:ii %product angle resolution
    dotColor = colorPlate(randi(100),:);
    ind = find(matchPoints(:,1)==i);
    %positions = zeros(size(ind,1),2);
    %productPositions = [matchPoints(ind,2)+matchPoints(ind,8) matchPoints(ind,3)+matchPoints(ind,9)];
    productPositions = [matchPoints(ind,2) matchPoints(ind,3) matchPoints(ind,8) matchPoints(ind,9) matchPoints(ind,6) matchPoints(ind,7)];
    try
        delete(handleSubPlotProduct);
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
   
        
        %ploting the matched points on shelf (unfiltered) [white]
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
        delete(handleSubPlotSlidingWindowLEFT);
        delete(handleSubPlotSlidingWindowRIGHT);
        catch exp
        end
        
        %ploting the matched points on product (unfiltered) [white]
        figure(888);
        handleSubPlotProduct = subplot(2,4,1);
        imshow(pImage);hold on;
        plot(C_data.data(:,1), C_data.data(:,2), 'white*', 'MarkerSize',5);
        
        %calculating the vector from each Matching point to center
        %(PRODUCT) and paint them [blue lines]
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
        
        %this will mark the intersection point [blue and yellow 'o']
        subplot(handleSubPlotProduct); hold on; %subplot(2,4,1);
        plot(C_data.mean(1),C_data.mean(2),'bo','MarkerFaceColor','y','LineWidth',2) 
        
        rectX = max(positions(:,1)-1*meanForFigure(3),0); 
        rectY = max(positions(:,2)-1*meanForFigure(4),0);
        sub_shelf = imcrop(routeIndex.shelves,[rectX(1) rectY(1) 6*meanForFigure(3) 6*meanForFigure(4)] );
        handleSubPlotSlidingWindowLEFT = subplot(2,4,5);
        imshow(sub_shelf);hold on;
        %ploting the matched points on sliding window (unfiltered) [white]
        plot(meanForFigure(3)+positions(:,3),meanForFigure(4)+positions(:,4), 'white*' , 'MarkerSize',5); 
        
	
        %draw the vectors on the SLIDING WINDOW which captured were on
        %product [blue lines]
        maxMean = max(meanForFigure(3),meanForFigure(4)); %furthestLengh = double(((C_data.sortData(dataHeight,1) - C_data.sortData(1,1))^2 + (C_data.sortData(dataHeight,2) - C_data.sortData(1,2))^2))^0.5;
        numberOfTheoreticalIntersects = (dataHeight  - 1)*(dataHeight / 2);
        intersections = zeros(numberOfTheoreticalIntersects,5);
        lines = zeros(dataHeight,4);
        %
        subplot(handleSubPlotSlidingWindowLEFT); hold on;
        %
        for iLine = 1:dataHeight
            x = meanForFigure(3)+positions(iLine,3);
            y = meanForFigure(4)+positions(iLine,4);
             
            X = double([x x+maxMean*C_data.data(iLine,5)]); %X = double([x x+furthestLengh*C_data.data(iLine,5)]);
            Y = double([y y+maxMean*C_data.data(iLine,6)]); %Y = double([y y+furthestLengh*C_data.data(iLine,6)]);
            
            
            line(X,Y);
            lines(iLine,:) = [X(1) Y(1) X(2) Y(2)]; 
        end
        
        cappedRunTimes = 0;
        bDataToAnalyze = false;
        while(cappedRunTimes < 3)
            bCapped = false;
            if(numberOfTheoreticalIntersects > numberOfIntersectsTresh)
                rng('shuffle');
                intersectPos = randperm(numberOfTheoreticalIntersects);
                intersectPos = intersectPos(1:numberOfIntersectsTresh);
                intersectPos = sort(intersectPos); 
                bCapped = true;
            end
            

            time = tic;
            %calculating the intersections of all vectors with each other
            iNd = 1;
            forCounter = 1;
            nextVal = 1;
            for line1Index = 1:dataHeight
                for line2Index = 1:line1Index
                    forCounter = forCounter +1;
                    if(line1Index ~= line2Index)
                        if(bCapped)
                            if(nextVal > numberOfIntersectsTresh)
                                break;
                            end
                            while(forCounter > intersectPos(nextVal))
                                nextVal = nextVal+1;
                                % not right position
                            end
                            
                            if(forCounter ~= intersectPos(nextVal))
                                continue;
                            else
                                % position match to random set
                                nextVal = nextVal + 1;
                            end
                        end
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
            timeToc = toc(time);

            %get real intersections
            intersections = intersections((intersections(:,1) ~= 0 & intersections(:,2) ~= 0),:);

            if(size(intersections,1) < 3)
                if(bCapped)
                  cappedRunTimes = cappedRunTimes+1;
                  continue;
                else
                    break;
                end
            end

            meanInterSection = mean(intersections);
            
            %calculating the vector from each Matching point to mean center of
            %intersections (ON SHELF)
            %
            subplot(handleSubPlotSlidingWindowLEFT); hold on;
            %
            for iLine = 1:dataHeight
                xPoint = meanForFigure(3)+positions(iLine,3);
                yPoint = meanForFigure(4)+positions(iLine,4);

                X = double([xPoint meanInterSection(1)]);
                Y = double([yPoint meanInterSection(2)]);

                

                xx = X(2) - X(1);
                yy = Y(2) - Y(1);

                V = [xx yy];
                V1=V/norm(V);

                C_data.data(iLine,7:8) = V1;

                [thetaShelf,~] = cart2pol(V1(1),V1(2));
                [thetaProduct,~] = cart2pol(C_data.data(iLine,5),C_data.data(iLine,6));

                C_data.data(iLine,9)=(abs(thetaShelf-thetaProduct))*180/pi;
                
                %draw matching vectors in red (on sliding window)
                if(C_data.data(iLine,9) < diffAngleTresh)
                    line(X,Y , 'Color' , 'red');
                end
            end
            matchInds = find(C_data.data(:,9) < diffAngleTresh);
            
            subplot(handleSubPlotSlidingWindowLEFT);hold on; %subplot(2,4,5);          
            plot(meanForFigure(3)+positions(matchInds,3),meanForFigure(4)+positions(matchInds,4), '*' , 'color' , dotColor , 'MarkerSize',5); 
            %mean of all creteria passed intersections point [blue and yellow 'o']
            plot(meanInterSection(1),meanInterSection(2),'bo','MarkerFaceColor','y','LineWidth',2);
        

            %if number of matches is below tresh (typ 40%)
            if(size(matchInds,1) / dataHeight < abortTresh) 
                if(bCapped) 
                    intersectionAndTreshRatio = numberOfTheoreticalIntersects/numberOfIntersectsTresh;
                    if (intersectionAndTreshRatio > 2 && cappedRunTimes < 3)
                        %if we got enought data to randomly get a new not
                        %overlapping set in a good propability and we did
                        %this less than 3 times already
                    else
                        %although we are on capped run - other choice of
                        %intersection probably wont help us
                        break;
                    end
                else
                    %we are on a regular run with inceficient matches ,
                    %lets go out to the next sliding window
                    break;
                end
            else
                intersections(:,5) = ismember(intersections(:,3),matchInds) & ismember(intersections(:,4),matchInds);
                bDataToAnalyze = true;
                break; % walkaround for the do..while for 1 loop
            end



            cappedRunTimes = cappedRunTimes + 1;
        end
        
        if(~bDataToAnalyze) %was kicked out of the while(true) with no results
            continue;
        end
        
        %calculate the position of center @ PRODUCT so we could position
        %the matching @ SLIDING WINDOW accordingly
        C_data.ptRectangleOffset.left = C_data.mean(1);
        C_data.ptRectangleOffset.right = length(pImage(1,:,1)) - C_data.mean(1);
        C_data.ptRectangleOffset.top = C_data.mean(2);
        C_data.ptRectangleOffset.bottom = length(pImage(:,1,1)) - C_data.mean(2);
         


        %% example of conturing
%         figure(888);
%         subplot(2,4,1);
%         hold on;
%         plot(C_data.original(dotInds,1),C_data.original(dotInds,2), '*' , 'color' , dotColor , 'MarkerSize',5);
%         hold on;
%         plot(C_data.mean(1),C_data.mean(2), '--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',10);
%        hold on;
        

             

        handleSubPlotSlidingWindowRIGHT = subplot(2,4,6);
        imshow(sub_shelf);hold on;
        %all points
        plot(meanForFigure(3)+positions(:,3),meanForFigure(4)+positions(:,4), 'white*' ,'MarkerSize',5);
        %matching points
        plot(meanForFigure(3)+positions(matchInds,3),meanForFigure(4)+positions(matchInds,4), '*' , 'Color' , dotColor, 'MarkerSize',5); 
        %mean of matches @ Shelf (no accurate to not matching at all)
        %[blue and red 'o']
        plot(meanForFigure(3) + C_data.mean(3),meanForFigure(4) + C_data.mean(4),'bo','MarkerFaceColor','r','LineWidth',2) %this will mark the intersection point with red 'o'
        %mean of all creteria passed intersections point
        %[blue and yellow 'o']
        plot(meanInterSection(1),meanInterSection(2),'bo','MarkerFaceColor','y','LineWidth',2) %this will mark the intersection point with red 'o'
        
       
        rectangle('Position',[meanInterSection(1) - C_data.ptRectangleOffset.left,...
                              meanInterSection(2) - C_data.ptRectangleOffset.top,...
                              C_data.ptRectangleOffset.left + C_data.ptRectangleOffset.right,...
                              C_data.ptRectangleOffset.top + C_data.ptRectangleOffset.bottom]);
            
           
        %% example of conturing
        
        figure(888); subplot(2,4,[3 4 7 8]);hold on;
        rectangle('Position',[positions(1,1) + C_data.mean(3) - C_data.ptRectangleOffset.left,...
                          positions(1,2) + C_data.mean(4) - C_data.ptRectangleOffset.top,...
                          C_data.ptRectangleOffset.left + C_data.ptRectangleOffset.right,...
                          C_data.ptRectangleOffset.top + C_data.ptRectangleOffset.bottom]);
                     

    end
end

