function params = getBeamScan(params,newset)
    params.beamScan = struct();
    if newset == false
        load(params.file.beamScan,"BRTx","BRRx","BUallTx","BUallRx","RUallTx","RUallRx");
        params.beamScan.BRTx = BRTx;
        params.beamScan.BRRx = BRRx;
        params.beamScan.BUTx = BUallTx(params.infra.UE.originalIndex);
        params.beamScan.BURx = BUallRx(params.infra.UE.originalIndex);
        params.beamScan.RUTx = RUallTx(:,params.infra.UE.originalIndex);
        params.beamScan.RURx = RUallRx(:,params.infra.UE.originalIndex);
    else
        load(params.file.channelsAll,"channelsBUall","channelsBR","channelsRUall")
        %% BR Beam
        params.beamScan.BRTx = zeros(1,params.infra.RS.number);
        params.beamScan.BRRx = zeros(1,params.infra.RS.number);
        for rs = 1:params.infra.RS.number
            WA = params.infra.BS.codebook;
            WB = params.infra.RS.codebook;
            H = channelsBR{rs};
            if nnz(H) == 0
                error("No BS-RS channel #%d",rs)
            end
            [TXi, RXi] = beamScan(WA, WB ,H);
            params.beamScan.BRTx(rs) = TXi;
            params.beamScan.BRRx(rs) = RXi;
        end

        %% BU Beam
        params.beamScan.BUcandidateTx = zeros(1,params.infra.UE.candidateNumber);
        params.beamScan.BUcandidateRx = zeros(1,params.infra.UE.candidateNumber);
        for ue = 1:params.infra.UE.candidateNumber
            WA = params.infra.BS.codebook;
            WB = params.infra.UE.codebook;
            H = channelsBUall{ue};
            [TXi, RXi] = beamScan(WA, WB ,H);
            params.beamScan.BUcandidateTx(ue) = TXi;
            params.beamScan.BUcandidateRx(ue) = RXi;
        end

        %% RU Beam
        params.beamScan.RUcandidateTx = zeros(params.infra.RS.number,params.infra.UE.candidateNumber);
        params.beamScan.RUcandidateRx = zeros(params.infra.RS.number,params.infra.UE.candidateNumber);
        for rs = 1:params.infra.RS.number
            for ue = 1:params.infra.UE.candidateNumber
                WA = params.infra.BS.codebook;
                WB = params.infra.UE.codebook;
                H = channelsRUall{rs,ue};
                [TXi, RXi] = beamScan(WA, WB ,H);
                params.beamScan.RUcandidateTx(rs,ue) = TXi;
                params.beamScan.RUcandidateRx(rs,ue) = RXi;
            end 
            disp(rs)
        end

        %% save
        BRTx = params.beamScan.BRTx;
        BRRx = params.beamScan.BRRx;
        BUallTx = params.beamScan.BUcandidateTx;
        BUallRx = params.beamScan.BUcandidateRx;
        RUallTx = params.beamScan.RUcandidateTx;
        RUallRx = params.beamScan.RUcandidateRx;
        params.beamScan.BUTx = BUallTx(params.infra.UE.originalIndex);
        params.beamScan.BURx = BUallRx(params.infra.UE.originalIndex);
        params.beamScan.RUTx = RUallTx(:,params.infra.UE.originalIndex);
        params.beamScan.RURx = RUallRx(:,params.infra.UE.originalIndex);
        save(params.file.beamScan,"BRTx","BRRx","BUallTx","BUallRx","RUallTx","RUallRx");
        disp("beam scan done!")
end