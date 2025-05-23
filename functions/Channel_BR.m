function H_BR = Channel_BR(params, index)
    NzB = params.infra.BS.antennaSize(1);
    NyB = params.infra.BS.antennaSize(2);
    NzR = params.infra.RS.antennaSize(1);
    NyR = params.infra.RS.antennaSize(2);
    Nrx = NzR * NyR;
    Ntx = NzB * NyB;
    lamda = params.lamda;
    targetRays = params.rays.BR{index};
    H_BR = zeros(Nrx, Ntx); 
    if(isempty(targetRays) == 1)
        error('rays为空！ BR:#%d',index)
    end
    pathNum = length(targetRays);
    
    for path = 1:pathNum
        AoA = deg2rad(targetRays(path).AngleOfArrival);
        AoD = deg2rad(targetRays(path).AngleOfDeparture);
        UPA_B = UPAvec(NyB, NzB, lamda, AoD(1), AoD(2));
        UPA_R = UPAvec(NyR, NzR, lamda, AoA(1), AoA(2));
        amFactor = sqrt(10^(-targetRays(path).PathLoss / 10));
        phaseShift = targetRays(path).PhaseShift;
        amFactorPlural = amFactor * exp(1j * phaseShift);
        H_BR = H_BR + amFactorPlural * UPA_R * UPA_B';
    end
    H_BR = H_BR *sqrt(Ntx*Nrx);
end