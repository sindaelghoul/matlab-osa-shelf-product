function [ routeIndex ] = SWadvance( routeIndex )
    if (routeIndex.bAdvance)
        routeIndex.Window = [routeIndex.WindowInitial(1) (routeIndex.Window(2) + -1*routeIndex.AdvanceOffset(2))];
        routeIndex.bAdvance = false;
    else
        routeIndex.Window(1) = routeIndex.Window(1) + routeIndex.AdvanceOffset(1);
    end
    

end

