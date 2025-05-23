function H_BU = Channel_BU(params, index)
    NzB = params.infra.BS.antennaSize(1);
    NyB = params.infra.BS.antennaSize(2);
    NzU = params.infra.UE.antennaSize(1);
    NyU = params.infra.UE.antennaSize(2);
    Nrx = NzU * NyU;
    Ntx = NzB * NyB;
    lamda = params.lamda;
    targetRays = params.rays.BU{index};
    H_BU = zeros(Nrx, Ntx); 
    if(isempty(targetRays) == 1)
        return;
    end
    pathNum = length(targetRays);
    
    for path = 1:pathNum
        AoA = deg2rad(targetRays(path).AngleOfArrival);
        AoD = deg2rad(targetRays(path).AngleOfDeparture);
        UPA_B = UPAvec(NyB, NzB, lamda, AoD(1), AoD(2));
        UPA_R = UPAvec(NyU, NzU, lamda, AoA(1), AoA(2));
        amFactor = sqrt(10^(-targetRays(path).PathLoss / 10));
        phaseShift = targetRays(path).PhaseShift;
        amFactorPlural = amFactor * exp(1j * phaseShift);
        H_BU = H_BU + amFactorPlural * UPA_R * UPA_B';
    end
    H_BU = H_BU *sqrt(Ntx*Nrx);    
end