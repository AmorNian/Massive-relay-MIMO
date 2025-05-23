function currentConflict = calculateConflict(params,res)
    currentConflict = 0;
    groupNumber = length(res);
    LoSRSMatrix = params.map.LoSRSMatrix;
    BRBeam = params.beamScan.BRTx;
    rsNumber = params.infra.RS.number;
    for group = 1:groupNumber
        user = res{group};
        selectedRSMatrix = LoSRSMatrix(:,user);
        for rs = 1:rsNumber
            rsVector = selectedRSMatrix(rs,:);
            rsConflict = sum(rsVector);
            if rsConflict >= 2
                currentConflict = currentConflict + rsConflict - 1;
            end
        end
        beamVector = any(selectedRSMatrix,2);
        activatedRS = beamVector == 1;
        beamVectorBeam = BRBeam(activatedRS);
        counts = accumarray(beamVectorBeam(:),1);
        repeatedCounts = counts(counts > 1);
        if ~isempty(repeatedCounts)
            currentConflict = currentConflict + repeatedCounts - length(repeatedCounts);
        end
    end
end