function [ specific_shelf_Compared_labeled_filled ] = FillGapOnShelf( specific_shelf_Compared_labeled )
 [specific_shelf_Compared_labeled numberOfBlobsExceptShelf] = bwlabel(not(specific_shelf_Compared), 4);


end

