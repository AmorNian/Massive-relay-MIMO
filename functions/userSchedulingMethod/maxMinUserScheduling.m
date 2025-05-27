function params = maxMinUserScheduling(params, otherParams)
    pattern = otherParams{1};
    ifRL = otherParams{2};
    if sum(pattern) ~= params.infra.UE.number
        error("pattern isn't matching UE number")
    end
    params.userScheduling.maxmin = struct();
    params.userScheduling.maxmin.pattern = pattern;
    params.userScheduling.maxmin.schedulingResult = cell(length(pattern), 1);
    userNum = params.infra.UE.number;
    assignedUser = false(1, userNum);
    pattern = sort(pattern);
    for group = 1:length(pattern)
        availableUser = find(~assignedUser);
        groupSize = pattern(group);
        if groupSize == 1
            combiCandidate = nchoosek(availableUser,2);
            conflictScore = zeros(size(combiCandidate, 1), 1);
            for i = 1:length(combiCandidate)
                conflictScore(i) = calculateConflict(params,{combiCandidate(i,:)});
            end
            maxConflictScore = max(conflictScore);
            maxCandidate = combiCandidate(conflictScore == maxConflictScore);
            bestCombi = maxCandidate(randi(size(maxCandidate,1)), :);
            targetUser = bestCombi(randi(2));
            params.userScheduling.maxmin.schedulingResult{group} = targetUser;
            assignedUser(targetUser) = true;
        else
            combiCandidate = nchoosek(availableUser,groupSize);
            conflictScore = zeros(size(combiCandidate, 1), 1);
            for i = 1:size(combiCandidate,1)
                conflictScore(i) = calculateConflict(params,{combiCandidate(i,:)});
            end
            maxConflictScore = max(conflictScore);
            maxCandidate = combiCandidate(conflictScore == maxConflictScore,:);
            bestCombi = maxCandidate(randi(size(maxCandidate,1)), :);
            targetUser = bestCombi(randi(length(bestCombi)));
            targetRows = any(combiCandidate == targetUser, 2);
            targetCombi = combiCandidate(targetRows, :);
            targetScore = conflictScore(targetRows);
            minConflict = min(targetScore);
            minCandidate = targetCombi(targetScore == minConflict, :);
            minCombi = minCandidate(randi(size(minCandidate,1)), :);
            params.userScheduling.maxmin.schedulingResult{group} = minCombi;
            assignedUser(minCombi) = true;
        end
    end
    isDone = all(assignedUser == 1);
    if ~isDone
        error("maxmin wrong! user is left!")
    end
    if ifRL == true
        params.resourceAllocation.maxmin = struct();
        params.resourceAllocation.maxmin.USMethod = "maxmin";
        params.resourceAllocation.maxmin.pattern = pattern;
        params.resourceAllocation.maxmin.subGroupNumber = length(pattern);
        params.resourceAllocation.maxmin.allocationResult = params.userScheduling.maxmin.schedulingResult;
    end     
end