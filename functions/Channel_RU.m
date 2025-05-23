function H_RU = Channel_RU(params, index1, index2)
    NzR = params.infra.RS.antennaSize(1);
    NyR = params.infra.RS.antennaSize(2);
    NzU = params.infra.UE.antennaSize(1);
    NyU = params.infra.UE.antennaSize(2);
    Nrx = NzU * NyU;
    Ntx = NzR * NyR;
    lamda = params.lamda;
    targetRays = params.rays.RU{index1, index2};
    H_RU = zeros(Nrx, Ntx); 
    if(isempty(targetRays) == 1)
        return;
    end
    pathNum = length(targetRays);
    
    for path = 1:pathNum
        AoA = deg2rad(targetRays(path).AngleOfArrival);
        AoD = deg2rad(targetRays(path).AngleOfDeparture);
        UPA_B = UPAvec(NyR, NzR, lamda, AoD(1), AoD(2));
        UPA_R = UPAvec(NyU, NzU, lamda, AoA(1), AoA(2));
        amFactor = sqrt(10^(-targetRays(path).PathLoss / 10));
        phaseShift = targetRays(path).PhaseShift;
        amFactorPlural = amFactor * exp(1j * phaseShift);
        H_RU = H_RU + amFactorPlural * UPA_R * UPA_B';
    end
    H_RU = H_RU *sqrt(Ntx*Nrx);  
end