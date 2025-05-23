function params = calculateChannels(params,newset)
    if newset == false
        load(params.file.channels,"channelsBR","channelsBUall")
        params.channel.BR = channelsBR;
        params.channel.BU = channelsBUall(params.infra.UE.originalIndex);
        params.channel.RU = cell(params.infra.RS.number,params.infra.UE.number);
        for i = 1:params.infra.RS.number
            for j = 1:params.infra.UE.number
                params.channel.RU{i,j} = Channel_RU(params,i,j);
            end
        end

    else         
        params.channel = struct();
        params.channel.BR = cell(1,params.infra.RS.number);
        params.channel.BUall = cell(1,params.infra.UE.candidateNumber);
        params.channel.RUall = cell(params.infra.RS.number,params.infra.UE.candidateNumber);
    
        for i = 1:params.infra.RS.number
            params.channel.BR{i} = Channel_BR(params,i);
        end
    
        for i = 1:params.infra.UE.candidateNumber
            params.channel.BUall{i} = Channel_BUall(params,i);
        end

        params.channel.RU = cell(params.infra.RS.number,params.infra.UE.number);
        for i = 1:params.infra.RS.number
            for j = 1:params.infra.UE.number
                params.channel.RU{i,j} = Channel_RU(params,i,j);
            end
        end
    
        for i = 1:params.infra.RS.number
            for j = 1:params.infra.UE.candidateNumber
                params.channel.RUall{i,j} = Channel_RUall(params,i,j);
            end
        end
        
        channelsBR = params.channel.BR;
        channelsBUall = params.channel.BUall;
        channelsRUall = params.channel.RUall;
        params.channel.BU = channelsBUall(params.infra.UE.originalIndex);
        % params.channel.RU = channelsRUall(:,params.infra.UE.originalIndex);
        save(params.file.channels,"channelsBR","channelsBUall")
        save(params.file.channelsAll,"channelsBR","channelsBUall","channelsRUall",'-v7.3')
        disp("channel calculation done!")
    end
end