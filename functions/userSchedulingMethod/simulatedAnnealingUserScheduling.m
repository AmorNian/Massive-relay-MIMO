function params = simulatedAnnealingUserScheduling(params, pattern)
    if sum(pattern) ~= params.infra.UE.number
        error("pattern isn't matching UE number")
    end
    params.userScheduling.SA = struct();
    params.userScheduling.SA.initialTemperature = 500000;
    params.userScheduling.SA.coolingRate = 0.999999;
    params.userScheduling.SA.maxIteration = 20000;
    params.userScheduling.SA.minTemperature = 0;
    params.userScheduling.SA.maxPerturbSize = 0.5 * params.infra.UE.number - 1;
    
    params.userScheduling.SA.pattern = pattern;
    res = cell(length(pattern), 1);
    
    % generate the initial user set
    groupNumber = length(pattern);
    randomUser = randperm(params.infra.UE.number);
    indice = 1;
    for group = 1:groupNumber
        res{group} = randomUser(indice:indice + pattern(group) - 1);
        indice = indice + pattern(group);
    end
    currentConflict = calculateConflict(params,res);
    bestRes = res;
    bestConflict = currentConflict;

    temperature = params.userScheduling.SA.initialTemperature;
    iter = params.userScheduling.SA.initialTemperature;
    while iter > 0 && temperature > params.userScheduling.SA.minTemperature
        perturbSize = params.userScheduling.SA.maxPerturbSize * (temperature/params.userScheduling.SA.initialTemperature);
        perturbSize = ceil(perturbSize);
        newRes = bestRes;
        for p = 1:perturbSize
            group1 = randi(groupNumber);
            group2 = randi(groupNumber);
            while group2 == group1
                group2 = randi(groupNumber);
            end

            if ~isempty(newRes{group1}) && ~isempty(newRes{group2})
                user1 = randi(length(newRes{group1}));
                user2 = randi(length(newRes{group2}));
                temp = newRes{group1}(user1);
                newRes{group1}(user1) = newRes{group2}(user2);
                newRes{group2}(user2) = temp;
            end
        end

        currentConflict = calculateConflict(params,newRes);
        if bestConflict < currentConflict
            bestRes = newRes;
            bestConflict = currentConflict;
        else
            probability = exp((currentConflict - bestConflict) / temperature);
            if rand() < probability
                bestRes = newRes;
                bestConflict = currentConflict;
            end
        end
        iter = iter - 1;
        temperature = temperature * params.userScheduling.SA.coolingRate;
    end
    params.userScheduling.SA.schedulingResult = bestRes;
    disp(bestConflict)
end