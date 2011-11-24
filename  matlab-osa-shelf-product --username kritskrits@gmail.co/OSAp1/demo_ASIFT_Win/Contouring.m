%function [ output_args ] = Contouring( input_args )

figure(6);
imshow(routeIndex.shelves);

for i=1:ii %product resolution
    dotColor = colorPlate(randi(100),:);
    ind = find(matchPoints(:,1)==i);
    %positions = zeros(size(ind,1),2);
    %productPositions = [matchPoints(ind,2)+matchPoints(ind,8) matchPoints(ind,3)+matchPoints(ind,9)];
    productPositions = [matchPoints(ind,2) matchPoints(ind,3) matchPoints(ind,8) matchPoints(ind,9) matchPoints(ind,6) matchPoints(ind,7)];
    
    j=1;
    while (j ~= size(productPositions,1)) %object resolution
        matchInds = find((productPositions(:,1) == productPositions(j,1)) & (productPositions(:,2) == productPositions(j,2)));
        j=j+size(matchInds,1); %advance in j , substructing 1
        positions = productPositions(matchInds,:);
        figure(6);
        hold on;
        plot(positions(:,1)+positions(:,3),positions(:,2)+positions(:,4), '*' , 'color' , dotColor , 'MarkerSize',5*(ii-(i-1))); 
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

    end
end

