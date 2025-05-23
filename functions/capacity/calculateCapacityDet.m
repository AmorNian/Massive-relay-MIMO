function params = calculateCapacityDet(params,otherParamsRS)
    method = otherParamsRS;   
    params.capacity.channelCapacity = zeros(1,params.infra.UE.number);
    B = params.bandwidth;
    P = params.infra.BS.transmitPower;
    subUserGroups = params.resourceAllocation.(method).allocationResult;
    groupNumber = params.relaySelection.groupNumber;
    
    for user = 1:params.infra.UE.number
        userGroup = 0;
        for group = 1:groupNumber
            if ismember(user,subUserGroups{group})
                userGroup = group;
                break
            end
        end
        if userGroup == 0
            error("User Group Error!(capacity)")
        end
        RSNumber = length(find(params.relaySelection.result(userGroup,:) > 0));
        Heff = params.capacity.effectiveChannels{user};
        Pk = params.capacity.precodingUE{user};
        Hk = Heff * Pk;
        Rk = Hk * Hk';
        capacity = B * real(log2(det(eye(size(Rk)) + Rk * (P / RSNumber) / params.capacity.noisePower(1,user))));
        capacity = capacity / groupNumber;
        params.capacity.channelCapacity(user) = capacity;
        disp(capacity)
    end 
end