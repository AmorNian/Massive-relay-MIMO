RSFile = "RSInitShinjuku.mat";
mapFile = "Shinjuku.osm";
%load("config\RSInitShinjuku.mat")
bslat = 35.688842;
bslon = 139.726793;
% rslat = [];
% rslon = [];
viewer = siteviewer("Name","NewYork","Basemap","streets","Buildings",mapFile);
BS = txsite("AntennaHeight",3,...
        "Latitude",bslat,...
        "Longitude",bslon,...
        "TransmitterFrequency",28e9,...
        "TransmitterPower",126,...
        "Name","BaseStation");
show(BS)
RS_NUM = length(rslat);
RS_Name = cell(RS_NUM,1);
for i = 1:RS_NUM
    RS_Name{i} = num2str(i);
end
RS_rx = rxsite("Name",RS_Name,...
    "Latitude",rslat,...
    "Longitude",rslon,...
    "AntennaHeight",2,...
    "ReceiverSensitivity",-80);
show(RS_rx)
pm = propagationModel("raytracing");
pm.Method = 'sbr';
pm.AngularSeparation = 'high';
pm.MaxNumReflections = 2;
pm.MaxNumDiffractions = 0;
rays = raytrace(BS,RS_rx,pm);
for i = 1:RS_NUM
    if isempty(rays{i}) == true
        error("#%d RS is blocked!",i)
    else
        if rays{i}(1).LineOfSight == false
            error("#%d RS is NLOS!",i)
        end
    end
end
save("config\RSInitShinjuku.mat","rslat","rslon")