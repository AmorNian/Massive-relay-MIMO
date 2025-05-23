function params = calculateEffectiveChannel(params,otherParamsRS)
    method = otherParamsRS;    
    params.capacity.effectiveChannels = cell(1,params.infra.UE.number);
    groupNumber = params.relaySelection.groupNumber;
    params.capacity.WBS = cell(1, groupNumber);
    params.capacity.VUE = cell(1, params.infra.UE.number);
    G = params.infra.RS.gain;
    for group = 1:groupNumber
        selectedRS = find(params.relaySelection.result(group,:) > 0);
        BSTxBeamIndex = sort(params.beamScan.BRTx(selectedRS));
        for user = params.resourceAllocation.(method).allocationResult{group} 
            if params.map.LoSBStoUE(user) == true
                BStoUELoStx = params.beamScan.BUTx(user);
                if ismember(BStoUELoStx,BSTxBeamIndex) == false
                    BSTxBeamIndex = [BSTxBeamIndex,BStoUELoStx];
                end
            end
        end
        WBS = params.infra.BS.codebook(:,sort(BSTxBeamIndex));
        params.capacity.WBS{group} = WBS;
        for user = params.resourceAllocation.(method).allocationResult{group} 
            Heff = 0;
            UEselectedRS = find(params.relaySelection.result(group,:) == user);
            UERxBeamIndex = sort(params.beamScan.RURx(UEselectedRS,user))';
            if params.map.LoSBStoUE(user) == true
                BStoUELoSrx = params.beamScan.BURx(user);
                if ismember(BStoUELoSrx,UERxBeamIndex) == false
                    UERxBeamIndex = [UERxBeamIndex,BStoUELoSrx];
                end
            end
            VUE = params.infra.UE.codebook(:,sort(UERxBeamIndex));
            params.capacity.VUE{user} = VUE;
            for rs = selectedRS
                HBR = params.channel.BR{rs};
                RSRXBeamIndex = params.beamScan.BRRx(rs);
                VRS = params.infra.RS.codebook(:,RSRXBeamIndex);
                RSTXBeamIndex = params.beamScan.BRTx(rs);
                WRS = params.infra.RS.codebook(:,RSTXBeamIndex);
                HRU = params.channel.RU{rs,user};
                Heff = Heff + HRU * WRS * G * VRS' * HBR * WBS;  
            end
            %% judge BS-UE LoS
            if params.map.LoSBStoUE(user) == true
                HBU = params.channel.BU{user};
                Heff = Heff + HBU * WBS;
            end
            Heff = VUE' * Heff;
            params.capacity.effectiveChannels{user} = Heff;
        end

    end
end