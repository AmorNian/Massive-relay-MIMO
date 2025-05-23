function params = judgeLoSRS(params)
    params.infra.UE.LoSRS = cell(1, params.infra.UE.number);
    params.infra.RS.LoSUE = cell(1, params.infra.RS.number);
    params.map.LoSRSMatrix = zeros(params.infra.RS.number, params.infra.UE.number);
    for i = 1:params.infra.RS.number
        for j = 1:params.infra.UE.number
            if isempty(params.rays.RU{i, j}) == false
                targetRay = params.rays.RU{i, j}(1);
                if targetRay.LineOfSight == true
                    params.infra.UE.LoSRS{j}(end+1) = i;
                    params.infra.RS.LoSUE{i}(end+1) = j;
                    params.map.LoSRSMatrix(i,j) = true; 
                end
            end
        end
    end
    %% judge Los BS-UE
    params.map.LoSBStoUE = zeros(1,params.infra.UE.number);
    for i = 1:params.infra.UE.number
        if isempty(params.rays.BU{i}) == false
            if params.rays.BU{i}(1).LineOfSight == true
                params.map.LoSBStoUE(i) = 1;
            end
        end
    end
end