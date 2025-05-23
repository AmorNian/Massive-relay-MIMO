function params = LoSRSBasedRelaySelection(params, otherParamsRS)
    % 输入参数解析
    USorRA = otherParamsRS{1};
    method = otherParamsRS{2};
    LoSRSMatrix = params.map.LoSRSMatrix;
    subUserGroups = params.(USorRA).(method).allocationResult;
    distanceMatrix = params.map.distance.RU;
    beamTx = params.beamScan.BRTx; % 基站到中继的发射波束（1×中继数）
    
    % 参数校验
    groupNumber = numel(subUserGroups);
    relayNumber = size(LoSRSMatrix, 1);
    if relayNumber ~= params.infra.RS.number
        error("中继数量不匹配！");
    end
    
    % 初始化输出结构
    params.relaySelection = struct();
    params.relaySelection.USorRA = USorRA;
    params.relaySelection.RAmethod = method;
    params.relaySelection.result = zeros(groupNumber, relayNumber);

    % 第一阶段：分配完全不冲突的中继（一对一且无波束冲突）
    for groupIdx = 1:groupNumber
        groupUsers = subUserGroups{groupIdx};
        assignedBeams = []; % 记录当前组已分配的波束
        
        % 找出专属中继（只连接本组单个用户且波束不冲突的中继）
        for r = 1:relayNumber
            connectedUsers = find(LoSRSMatrix(r, groupUsers));
            if numel(connectedUsers) == 1
                % 检查波束冲突
                if ~any(beamTx(r) == assignedBeams)
                    params.relaySelection.result(groupIdx, r) = groupUsers(connectedUsers);
                    assignedBeams(end+1) = beamTx(r); % 记录已分配波束
                end
            end
        end
    end

    % 第二阶段：公平分配冲突中继（考虑波束冲突）
    for groupIdx = 1:groupNumber
        groupUsers = subUserGroups{groupIdx};
        
        % 获取当前组已分配的中继及其波束
        assignedRelays = find(params.relaySelection.result(groupIdx, :) > 0);
        assignedBeams = beamTx(assignedRelays);
        
        % 找出可共享的中继（连接多个用户的中继）
        potentialRelays = find(sum(LoSRSMatrix(:, groupUsers), 2) > 0)';
        conflictRelays = setdiff(potentialRelays, assignedRelays);
        
        % 持续分配直到没有可用中继
        while ~isempty(conflictRelays)
            % 统计各用户当前中继数
            userRelayCounts = arrayfun(@(u) sum(params.relaySelection.result(groupIdx, :) == u), groupUsers);
            
            % 找出中继数最少的用户们
            minCount = min(userRelayCounts);
            candidateUsers = groupUsers(userRelayCounts == minCount);
            
            % 为每个候选用户分配可用的冲突中继
            for user = candidateUsers
                % 找出用户可连接的中继
                userRelays = find(LoSRSMatrix(:, user))';
                
                % 筛选未分配且不引起波束冲突的中继
                availableRelays = [];
                for r = intersect(userRelays, conflictRelays)
                    if ~any(beamTx(r) == assignedBeams)
                        availableRelays(end+1) = r;
                    end
                end
                
                if ~isempty(availableRelays)
                    % 选择距离最近的中继
                    [~, minIdx] = min(distanceMatrix(availableRelays, user));
                    selectedRelay = availableRelays(minIdx);
                    
                    % 执行分配
                    params.relaySelection.result(groupIdx, selectedRelay) = user;
                    assignedRelays(end+1) = selectedRelay;
                    assignedBeams(end+1) = beamTx(selectedRelay);
                    conflictRelays(conflictRelays == selectedRelay) = [];
                    
                    % 如果所有冲突中继已分配则提前退出
                    if isempty(conflictRelays)
                        break;
                    end
                end
            end
            
            % 防止意外无限循环（当所有剩余中继都存在波束冲突时退出）
            if all(cellfun(@(r) any(beamTx(r)==assignedBeams), num2cell(conflictRelays)))
                break;
            end
        end
    end
    params.relaySelection.groupNumber = groupNumber;
end

% function params = LoSRSBasedRelaySelection(params, otherParamsRS)
%     % 输入参数解析
%     USorRA = otherParamsRS{1};
%     method = otherParamsRS{2};
%     LoSRSMatrix = params.map.LoSRSMatrix;
%     subUserGroups = params.(USorRA).(method).allocationResult;
%     distanceMatrix = params.map.distance.RU;
% 
%     % 参数校验
%     groupNumber = numel(subUserGroups);
%     relayNumber = size(LoSRSMatrix, 1);
%     if relayNumber ~= params.infra.RS.number
%         error("中继数量不匹配！");
%     end
% 
%     % 初始化输出结构
%     params.relaySelection = struct();
%     params.relaySelection.USorRA = USorRA;
%     params.relaySelection.RAmethod = method;
%     params.relaySelection.result = zeros(groupNumber, relayNumber);
% 
%     % 第一阶段：分配完全不冲突的中继（一对一）
%     for groupIdx = 1:groupNumber
%         groupUsers = subUserGroups{groupIdx};
% 
%         % 找出专属中继（只连接本组单个用户的中继）
%         for r = 1:relayNumber
%             connectedUsers = find(LoSRSMatrix(r, groupUsers));
%             if numel(connectedUsers) == 1
%                 params.relaySelection.result(groupIdx, r) = groupUsers(connectedUsers);
%             end
%         end
%     end
% 
%     % 第二阶段：公平分配冲突中继
%     for groupIdx = 1:groupNumber
%         groupUsers = subUserGroups{groupIdx};
%         conflictRelays = find(sum(LoSRSMatrix(:, groupUsers), 2) > 1)'; % 可共享的中继
% 
%         % 持续分配直到没有冲突中继剩余
%         while ~isempty(conflictRelays)
%             % 统计各用户当前中继数
%             userRelayCounts = arrayfun(@(u) sum(params.relaySelection.result(groupIdx, :) == u), groupUsers);
% 
%             % 找出中继数最少的用户们
%             minCount = min(userRelayCounts);
%             candidateUsers = groupUsers(userRelayCounts == minCount);
% 
%             % 为每个候选用户分配最近的可用冲突中继
%             for user = candidateUsers
%                 % 找出用户可用的冲突中继
%                 availableRelays = find(LoSRSMatrix(:, user)' & ...
%                                     ismember(1:relayNumber, conflictRelays));
% 
%                 if ~isempty(availableRelays)
%                     % 选择距离最近的中继
%                     [~, minIdx] = min(distanceMatrix(availableRelays, user));
%                     selectedRelay = availableRelays(minIdx);
% 
%                     % 执行分配
%                     params.relaySelection.result(groupIdx, selectedRelay) = user;
%                     conflictRelays(conflictRelays == selectedRelay) = []; % 移除已分配中继
% 
%                     % 如果所有冲突中继已分配则提前退出
%                     if isempty(conflictRelays)
%                         break;
%                     end
%                 end
%             end
% 
%             % 防止意外无限循环
%             if all(arrayfun(@(r) any(params.relaySelection.result(groupIdx, r) == groupUsers), conflictRelays))
%                 break;
%             end
%         end
%     end
% end