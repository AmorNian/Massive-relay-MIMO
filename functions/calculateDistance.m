function params = calculateDistance(params)
    params.map.distance = struct();
    params.map.distance.BR = distance(params.infra.BS.txsite, params.infra.RS.rxsite)';
    params.map.distance.BU = distance(params.infra.BS.txsite, params.infra.UE.rxsite)';
    params.map.distance.RU = distance(params.infra.RS.txsite, params.infra.UE.rxsite)';
end