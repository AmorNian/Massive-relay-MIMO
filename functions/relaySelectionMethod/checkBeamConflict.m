function [hasConflict, conflictDetails] = checkBeamConflict(params)
    % 检查中继分配结果中的基站发射波束冲突
    % 输入:
    %   params - 包含中继分配结果和波束信息的参数结构体
    % 输出:
    %   hasConflict - 逻辑值，true表示存在冲突
    %   conflictDetails - 冲突详细信息的结构体数组

    % 获取必要数据
    relayAssignment = params.relaySelection.result; % 组×中继分配矩阵
    beamTx = params.beamScan.BRTx; % 中继对应的基站发射波束(1×中继数)
    numGroups = size(relayAssignment, 1);
    
    % 初始化输出
    hasConflict = false;
    conflictDetails = struct('group', {}, 'beam', {}, 'users', {}, 'relays', {});
    
    % 检查每组的中继分配
    for g = 1:numGroups
        % 获取本组已分配的中继索引
        assignedRelays = find(relayAssignment(g, :) > 0);
        
        if isempty(assignedRelays)
            continue; % 跳过未分配任何中继的组
        end
        
        % 获取这些中继对应的波束
        groupBeams = beamTx(assignedRelays);
        
        % 找出重复的波束(冲突)
        [uniqueBeams, ~, ic] = unique(groupBeams);
        beamCounts = accumarray(ic, 1);
        conflictBeams = uniqueBeams(beamCounts > 1);
        
        % 记录冲突信息
        if isempty(conflictBeams) == false
            for b = conflictBeams'
                conflictRelays = assignedRelays(groupBeams == b);
                conflictUsers = relayAssignment(g, conflictRelays);
                
                % 添加到冲突详情
                newConflict = struct(...
                    'group', g, ...
                    'beam', b, ...
                    'users', conflictUsers, ...
                    'relays', conflictRelays);
                conflictDetails(end+1) = newConflict;
                
                hasConflict = true;
            end
        end
    end
    
    % 如果没有冲突，返回空结构
    if ~hasConflict
        conflictDetails = struct('group', {}, 'beam', {}, 'users', {}, 'relays', {});
    end


    if hasConflict
        disp('发现波束冲突：');
        for i = 1:length(conflictDetails)
            fprintf('组%d: 波束%d被用户%s通过中继%s共享\n', ...
                conflictDetails(i).group, ...
                conflictDetails(i).beam, ...
                mat2str(conflictDetails(i).users), ...
                mat2str(conflictDetails(i).relays));
        end
    else
        disp('无波束冲突');
    end

end