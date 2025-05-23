function params = cartesianCoordinate(params)
    originLat = params.map.originLatitude;
    originLon = params.map.originLongitude;
    xAxisLat = params.map.xAxisLat;
    xAxisLon = params.map.xAxisLon;
    params.map.cartesianCoordinate = struct();
    latBS = params.infra.BS.latitude;
    lonBS = params.infra.BS.longitude;
    latRS = params.infra.RS.latitude;
    lonRS = params.infra.RS.longitude;
    latUE = params.infra.UE.latitude;
    lonUE = params.infra.UE.longitude;
    params.map.cartesianCoordinate.BS = latLonToCartesian(latBS, lonBS, originLat, originLon, xAxisLat, xAxisLon);
    params.map.cartesianCoordinate.RS = latLonToCartesian(latRS, lonRS, originLat, originLon, xAxisLat, xAxisLon);
    params.map.cartesianCoordinate.UE = latLonToCartesian(latUE, lonUE, originLat, originLon, xAxisLat, xAxisLon);
end