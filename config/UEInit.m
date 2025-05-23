street(1).start = [35.690044,139.726381];
street(1).end = [35.688421,139.725476];
street(2).start = [35.689739,139.727185];
street(2).end = [35.688049,139.726305];
street(3).start = [35.688532,139.727562];
street(3).end = [35.687703,139.727139];
street(4).start = [35.689225,139.725934];
street(4).end = [35.688532,139.727562];
street(5).start = [35.688421,139.725476];
street(5).end = [35.687703,139.727139];
street(6).start = [35.690044,139.726381];
street(6).end = [35.689739,139.727185];
interval = 2;
[uelat, uelon] = calculateStreetPoints(street, interval);

RSFile = "RSInitShinjuku.mat";
mapFile = "Shinjuku.osm";
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
uename = "UE#" + (1:length(uelat))';
UE = rxsite("AntennaHeight",1.6,...
        "Latitude",uelat,...
        "Longitude",uelon,...
        "Name",uename);


RS = txsite("AntennaHeight",2,...
        "Latitude",rslat,...
        "Longitude",rslon,...
        "TransmitterFrequency",28e9,...
        "TransmitterPower",126);
show(RS)

pm = propagationModel("raytracing");
pm.Method = 'sbr';
pm.AngularSeparation = 'high';
pm.MaxNumReflections = 2;
pm.MaxNumDiffractions = 0;
rays = raytrace(RS,UE,pm);

for ue = 1:length(uelat)
    flag = false;
    for rs = 1:length(rslat)
        if isempty(rays{rs,ue}) == false
            if rays{rs,ue}(1).LineOfSight == true
                flag = true;
            end
        end
    end
    if flag == false
        disp(ue)
        show(UE(ue))
    end
end

