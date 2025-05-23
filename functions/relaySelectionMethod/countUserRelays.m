function userRelayCount = countUserRelays(relayAssignmentResult, totalUsers)
    % 统计每个用户分配到的中继数量
    % 输入:
    %   relayAssignmentResult - 中继分配结果矩阵（组数×中继数），值为用户ID
    %   totalUsers - 总用户数
    % 输出:
    %   userRelayCount - 每个用户分配到的中继数量（1×totalUsers向量）

    % 初始化统计向量
    userRelayCount = zeros(1, totalUsers);
    
    % 遍历所有中继分配记录
    [numGroups, numRelays] = size(relayAssignmentResult);
    for g = 1:numGroups
        for r = 1:numRelays
            userID = relayAssignmentResult(g, r);
            if userID > 0  % 只统计有效分配
                userRelayCount(userID) = userRelayCount(userID) + 1;
            end
        end
    end
    disp('每个用户分配到的中继数量:');
    for u = 1:length(userRelayCount)
        fprintf('用户%d: %d个中继\n', u, userRelayCount(u));
    end
end