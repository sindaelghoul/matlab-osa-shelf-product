function [ C_data ] = RunASIFTandSaveResults(ii,rect_shelf, file_img1, file_img2 )
    global totalMatches;
    C_data = [];
    imgOutVert = 'pics\imgOutVert.png';
    imgOutHori = 'pics\imgOutHori.png';
    matchings = 'matchings.txt';
    keys1 = 'keys1.txt';
    keys2 = 'keys2.txt';
    flag_resize = 0;

    for iDex=1:3
        try
            delete(imgOutVert,imgOutHori,matchings,keys1,keys2);
            disp(['deleting old files...']);
            demo_ASIFT(file_img1, file_img2, imgOutVert, imgOutHori, matchings, keys1, keys2, flag_resize);
        catch ex
        end

        %% read matching data from file
        fid = fopen(matchings);

        %read number of matches
        matches = cell2mat(textscan(fid, '%d',1));
        
        
            % read numeric data
            for k = 1 : matches
                C_data = [C_data; int32([ii rect_shelf]) textscan(fid, '%d %d %d %d',1)];
            end
            C_data = cell2mat(C_data);
            
            
        fclose(fid);
        
        if(matches ~= 0)
            totalMatches = totalMatches+1;
            return;
        end

        
    end

end

