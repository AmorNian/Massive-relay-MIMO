function params = calculateNoisePower(params,otherParamsRS)
    method = otherParamsRS;
    params.capacity.noisePower = zeros(2,params.infra.UE.number);
    sigma = params.k * params.temperture * params.bandwidth * params.noiseFigure;
    groupNumber = params.relaySelection.groupNumber;
    G = params.infra.RS.gain;
    for group = 1:groupNumber
        selectedRS = find(params.relaySelection.result(group,:) > 0);
        for user = params.resourceAllocation.(method).allocationResult{group} 
            noise = 0;
            for rs = selectedRS
                RSTXBeamIndex = params.beamScan.BRTx(rs);
                WRS = params.infra.RS.codebook(:,RSTXBeamIndex);
                HRU = params.channel.RU{rs,user};
                noise = noise + HRU * WRS * G;  
            end
            VUE = params.capacity.VUE{user};
            noise = VUE' * noise;
            noisePower = mean(abs(noise).^2) * sigma + sigma;
            params.capacity.noisePower(1,user) = noisePower;
            params.capacity.noisePower(2,user) = 10*log10(noisePower);
        end
    end
end