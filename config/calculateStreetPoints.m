function [lat_array, lon_array] = calculateStreetPoints(street_segments, interval_m)
    % 输入：
    %   street_segments - 结构数组，包含每条街道的起点和终点坐标
    %     例如: street_segments(1).start = [lat1, lon1]
    %           street_segments(1).end = [lat2, lon2]
    %   interval_m - 采样间隔距离（米）
    % 输出：
    %   lat_array - 所有采样点的纬度数组
    %   lon_array - 所有采样点的经度数组
    
    earth_radius = 6371000; % 地球半径（米）
    lat_array = [];
    lon_array = [];
    
    for i = 1:length(street_segments)
        start_point = street_segments(i).start;
        end_point = street_segments(i).end;
        
        % 计算街道总长度
        distance = haversine(start_point, end_point, earth_radius);
        
        % 计算需要采样的点数
        num_points = ceil(distance / interval_m) + 1;
        if num_points < 2
            num_points = 2;
        end
        
        % 计算插值比例
        ratios = linspace(0, 1, num_points);
        
        % 插值计算每个点的坐标
        for j = 1:num_points
            [lat, lon] = interpolatePoint(start_point, end_point, ratios(j), earth_radius);
            lat_array = [lat_array; lat];
            lon_array = [lon_array; lon];
        end
    end
end

function distance = haversine(point1, point2, radius)
    % 使用Haversine公式计算两点间距离
    lat1 = deg2rad(point1(1));
    lon1 = deg2rad(point1(2));
    lat2 = deg2rad(point2(1));
    lon2 = deg2rad(point2(2));
    
    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    
    a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    distance = radius * c;
end

function [lat, lon] = interpolatePoint(start_point, end_point, ratio, radius)
    % 在球面上进行线性插值，返回纬度和经度
    
    if ratio <= 0
        lat = start_point(1);
        lon = start_point(2);
        return;
    elseif ratio >= 1
        lat = end_point(1);
        lon = end_point(2);
        return;
    end
    
    lat1 = deg2rad(start_point(1));
    lon1 = deg2rad(start_point(2));
    lat2 = deg2rad(end_point(1));
    lon2 = deg2rad(end_point(2));
    
    % 计算两点间的角距离
    delta = haversine(start_point, end_point, 1); % 使用半径为1的球体
    
    % 计算插值点
    a = sin((1-ratio)*delta) / sin(delta);
    b = sin(ratio*delta) / sin(delta);
    
    x = a * cos(lat1) * cos(lon1) + b * cos(lat2) * cos(lon2);
    y = a * cos(lat1) * sin(lon1) + b * cos(lat2) * sin(lon2);
    z = a * sin(lat1) + b * sin(lat2);
    
    lat_rad = atan2(z, sqrt(x^2 + y^2));
    lon_rad = atan2(y, x);
    
    lat = rad2deg(lat_rad);
    lon = rad2deg(lon_rad);
end