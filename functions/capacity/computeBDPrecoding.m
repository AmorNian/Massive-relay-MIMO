function params = computeBDPrecoding(params,otherParamsRS)
    Heff = params.capacity.effectiveChannels;
    method = otherParamsRS;
    precoding = cell(1,params.relaySelection.groupNumber);
    precodingUE = cell(1,params.infra.UE.number);
    subUserGroups = params.resourceAllocation.(method).allocationResult;
    for group = 1:params.relaySelection.groupNumber
        for user = subUserGroups{group}
            H_interf = [];
            for user2 = subUserGroups{group}
                if user2 ~= user
                    H_interf = [H_interf; Heff{user2}];
                end
            end
            [~,~,V] = svd(H_interf);
            null_dim = size(V,2) - size(H_interf,1);
            Vnull = V(:, end-null_dim+1:end);
    
            Hk = Heff{user};
            if length(subUserGroups{group}) == 1
                Vnull = eye(size(Hk,2));
            end
            Hk_eff = Hk * Vnull;
            [~,~,Vk] = svd(Hk_eff);
            d_k = size(Hk,1);
            Pk = Vnull * Vk(:,1:d_k);
    
            precodingUE{user} = Pk;
            precoding{group} = [precoding{group}, Pk];
        end
    end
    params.capacity.precoding = precoding;
    params.capacity.precodingUE = precodingUE;
end

    