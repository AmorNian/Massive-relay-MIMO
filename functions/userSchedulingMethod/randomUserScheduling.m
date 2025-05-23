function params = randomUserScheduling(params, pattern)
    if sum(pattern) ~= params.infra.UE.number
        error("pattern isn't matching UE number")
    end
    randomPerm = randperm(params.infra.UE.number);
    params.userScheduling.random = struct();
    params.userScheduling.random.pattern = pattern;
    params.userScheduling.random.schedulingResult = cell(length(pattern), 1);
    currentIdx = 1;
    for i = 1:length(pattern)
        groupSize = pattern(i);
        params.userScheduling.random.schedulingResult{i} = randomPerm(currentIdx:currentIdx + groupSize - 1);
        currentIdx = currentIdx + groupSize;
    end
    for i = 1:length(params.userScheduling.random.schedulingResult)
        params.userScheduling.random.schedulingResult{i} = sort(params.userScheduling.random.schedulingResult{i});
    end
    params.userScheduling.random.midGroupNumber = length(params.userScheduling.random.schedulingResult);
end