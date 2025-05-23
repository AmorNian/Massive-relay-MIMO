function cartesianCoords = latLonToCartesian(latitudes, longitudes, originLat, originLon, xAxisLat, xAxisLon)
    % Constants
    R = 6371000; % Earth's radius in meters

    % Convert origin and x-axis point to radians
    originLat = deg2rad(originLat);
    originLon = deg2rad(originLon);
    xAxisLat = deg2rad(xAxisLat);
    xAxisLon = deg2rad(xAxisLon);
    
    % Calculate the angle of the x-axis direction in radians
    deltaLon = xAxisLon - originLon;
    deltaLat = xAxisLat - originLat;
    angleX = atan2(deltaLat, deltaLon);

    % Initialize output array
    numPoints = length(latitudes);
    cartesianCoords = zeros(numPoints, 2); % Columns are x and y coordinates

    % Convert each latitude and longitude to Cartesian coordinates
    for i = 1:numPoints
        % Convert to radians
        lat = deg2rad(latitudes(i));
        lon = deg2rad(longitudes(i));
        
        % Calculate distances in the north-south and east-west directions
        deltaLon = lon - originLon;
        deltaLat = lat - originLat;

        % Calculate distance from the origin
        distance = R * sqrt(deltaLat^2 + (cos((lat + originLat) / 2) * deltaLon)^2);
        
        % Calculate angle relative to the origin
        angle = atan2(deltaLat, deltaLon) - angleX;

        % Convert polar coordinates to Cartesian
        x = distance * cos(angle);
        y = distance * sin(angle);
        
        % Store result
        cartesianCoords(i, :) = [x, y];
    end
end
