function params = getRaytracing(params,newset)
    params.rays = struct();
    if newset == false
        load(params.file.rays,"raysRUall","raysBUall","raysBR")
        params.rays.BR = raysBR;
        params.rays.BU = raysBUall(params.infra.UE.originalIndex);
        params.rays.RU = raysRUall(:,params.infra.UE.originalIndex);
        params.rays.BUcandidate = raysBUall;
        params.rays.RUcandidate = raysRUall;
    else      
        pm = params.raytrace;
        params.rays.BR = raytrace(params.infra.BS.txsite,params.infra.RS.rxsite,pm);
        params.rays.BU = raytrace(params.infra.BS.txsite,params.infra.UE.rxsite,pm);
        params.rays.RU = raytrace(params.infra.RS.txsite,params.infra.UE.rxsite,pm);
        emptyIndicesBR = find(cellfun(@isempty, params.rays.BR), 1);
        if ~isempty(emptyIndicesBR) error("blocked RS exist!"); end
        for i = 1:numel(params.rays.BR)
            if params.rays.BR{i}(1).LineOfSight ~= true
                error("NLOS RS #%d",i);
            end
        end

        load(params.infra.UE.configFile,"uelat","uelon");
        UEcandidateRxsite = rxsite("Latitude",uelat,...
                "Longitude",uelon,...
                "Antenna",params.infra.UE.antenna,...
                "AntennaHeight",params.infra.UE.antennaHeight,...
                "ReceiverSensitivity",params.infra.RS.receiverSensitivitydB);
        params.rays.BUcandidate = raytrace(params.infra.BS.txsite,UEcandidateRxsite,pm);
        params.rays.RUcandidate = raytrace(params.infra.RS.txsite,UEcandidateRxsite,pm);
        raysBR = params.rays.BR;
        raysBUall = params.rays.BUcandidate;
        raysRUall = params.rays.RUcandidate;
        save(params.file.rays,"raysRUall","raysBUall","raysBR")
        disp("raytracing done!")
    end
end