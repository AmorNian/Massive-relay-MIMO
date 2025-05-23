function [TXi, RXi] = beamScan(WA, WB ,H)
    beamNumA = size(WA, 2);
    beamNumB = size(WB, 2);
    TXi = 1;
    RXi = 1;
    max = abs(WB(:,1)' * H * WA(:,1));
    if max == 0
        TXi = 0;
        RXi = 0;
        return
    end
    for i = 1:beamNumA
       for j = 1:beamNumB
           h = abs(WB(:,j)' * H * WA(:,i));
           if h>=max
               max = h;
               TXi = i;
               RXi = j;
           end
       end
    end
end