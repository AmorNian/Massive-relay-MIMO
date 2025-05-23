function params = randomResourceAllocation(params, otherParams)
    params.resourceAllocation.random = struct();
    params.resourceAllocation.random.USMethod = otherParams{2};
    params.resourceAllocation.random.pattern = otherParams{1};
    params.resourceAllocation.random.targetUserGroups = params.userScheduling.(otherParams{2}).schedulingResult;
    if length(params.resourceAllocation.random.targetUserGroups) ~= length(params.resourceAllocation.random.pattern)
        error('targetUserGroups and patternRA not matching');
    end
    totalSubGroups = 0;
    for i = 1:length(params.resourceAllocation.random.pattern)
        totalSubGroups = totalSubGroups + length(params.resourceAllocation.random.pattern{i});
    end
    params.resourceAllocation.random.subGroupNumber = totalSubGroups;
    params.resourceAllocation.random.allocationResult = cell(totalSubGroups, 1);
    currentIndex = 1; 

    for i = 1:length(params.resourceAllocation.random.targetUserGroups)
        currentGroup = params.resourceAllocation.random.targetUserGroups{i};  
        currentSizes = params.resourceAllocation.random.pattern{i};  
        N = length(currentGroup);  

        if sum(currentSizes) ~= N
            error('#%d Group and pattern not matching!', i);
        end

        shuffledIndices = randperm(N);
        shuffledGroup = currentGroup(shuffledIndices);

        startIdx = 1;
        for j = 1:length(currentSizes)
            subSize = currentSizes(j);
            params.resourceAllocation.random.allocationResult{currentIndex} = shuffledGroup(startIdx : startIdx + subSize - 1);
            startIdx = startIdx + subSize;
            currentIndex = currentIndex + 1;  
        end
    end
end