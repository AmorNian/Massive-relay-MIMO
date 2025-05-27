function params = singleUserScheduling(params, otherparamsUS)
    ifRL = otherparamsUS;
    params.userScheduling.single = struct();
    userNum = params.infra.UE.number;
    res = cell(userNum, 1);
    for i = 1:userNum
        res{i} = i;
    end
    params.userScheduling.single.schedulingResult = res;
    if ifRL
        params.resourceAllocation.single = struct();
        params.resourceAllocation.single.USMethod = "single";
        params.resourceAllocation.single.subGroupNumber = userNum;
        params.resourceAllocation.single.allocationResult = params.userScheduling.single.schedulingResult;
    end
end