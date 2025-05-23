function params = getParameters()
    params = struct();
    %% communication para
    params.freq = 28e9;
    params.bandwidth = 400e6;
    params.temperture = 300;
    params.c = physconst('LightSpeed');
    params.lamda = params.c/params.freq;
    params.k = physconst("Boltzmann");
    params.noiseFiguredB = 6;
    params.noiseFigure = 10^(params.noiseFiguredB/10);
    %% raytracing model
    params.raytrace = propagationModel("raytracing");
    params.raytrace.Method = 'sbr';
    params.raytrace.AngularSeparation = 'high';
    params.raytrace.MaxNumReflections = 2;
    params.raytrace.MaxNumDiffractions = 0;
    %% infrastructure para
    % base station
    params.infra.BS = struct();
    params.infra.BS.name = "Base Station";
    params.infra.BS.latitude = 35.688842;
    params.infra.BS.longitude = 139.726793;
    params.infra.BS.antennaSize = [16 16];
    params.infra.BS.antenna = phased.URA("Size",params.infra.BS.antennaSize,"ElementSpacing",0.5 * params.lamda);
    params.infra.BS.codebook = DFTCodeBook(params.infra.BS.antennaSize(1),params.infra.BS.antennaSize(2));
    params.infra.BS.antennaHeight = 3;
    params.infra.BS.transmitPower = 126;  % 126watt = 51dBm
    params.infra.BS.txsite = txsite("Antenna",params.infra.BS.antenna,...
                                    "AntennaHeight",params.infra.BS.antennaHeight,...
                                    "Latitude",params.infra.BS.latitude,...
                                    "Longitude",params.infra.BS.longitude,...
                                    "TransmitterFrequency",params.freq,...
                                    "TransmitterPower",params.infra.BS.transmitPower,...
                                    "Name",params.infra.BS.name);
 
    % relay station
    params.infra.RS = struct();
    params.infra.RS.configFile = "./config/RSInitShinjuku.mat";  % all the RS's lat & lon
    load(params.infra.RS.configFile,"rslat","rslon");
    if length(rslat) ~= length(rslon) error("RSconfigFile Error!"); end
    params.infra.RS.number = length(rslat);
    params.infra.RS.name = "RS#" + (1:params.infra.RS.number)';
    params.infra.RS.latitude = rslat;
    params.infra.RS.longitude = rslon;
    params.infra.RS.antennaSize = [16 16];
    params.infra.RS.antenna = phased.URA("Size",params.infra.RS.antennaSize,"ElementSpacing",0.5 * params.lamda);
    params.infra.RS.codebook = DFTCodeBook(params.infra.RS.antennaSize(1),params.infra.RS.antennaSize(2));
    params.infra.RS.antennaHeightRx = 3;
    params.infra.RS.antennaHeightTx = 2;
    params.infra.RS.transmitPower = 126;
    params.infra.RS.receiverSensitivitydB = -80;
    params.infra.RS.gaindB = 20;
    params.infra.RS.gain = 10^(params.infra.RS.gaindB/10);
    params.infra.RS.txsite = txsite("Name",params.infra.RS.name,...
                                    "Latitude",params.infra.RS.latitude,...
                                    "Longitude",params.infra.RS.longitude,...
                                    "Antenna",params.infra.RS.antenna,...
                                    "AntennaHeight",params.infra.RS.antennaHeightTx,...
                                    "TransmitterFrequency",params.freq,...
                                    "TransmitterPower",params.infra.RS.transmitPower);
    params.infra.RS.rxsite = rxsite("Name",params.infra.RS.name,...
                                    "Latitude",params.infra.RS.latitude,...
                                    "Longitude",params.infra.RS.longitude,...
                                    "Antenna",params.infra.RS.antenna,...
                                    "AntennaHeight",params.infra.RS.antennaHeightRx,...
                                    "receiverSensitivity",params.infra.RS.receiverSensitivitydB);
    
    % user equipment
    params.infra.UE = struct();
    params.infra.UE.configFile = "./config/UEInitShinjuku.mat";  % all the UE's lat & lon
    load(params.infra.UE.configFile,"uelat","uelon");
    if length(uelat) ~= length(uelon) error("UEconfigFile Error!"); end
    params.infra.UE.candidateNumber = length(uelat);
    params.infra.UE.number = 18;
    params.infra.UE.name = "UE#" + (1:params.infra.UE.number)';
    params.infra.UE.antennaSize = [12 12];
    params.infra.UE.antenna = phased.URA("Size",params.infra.UE.antennaSize,"ElementSpacing",0.5 * params.lamda);
    params.infra.UE.codebook = DFTCodeBook(params.infra.UE.antennaSize(1),params.infra.UE.antennaSize(2));
    params.infra.UE.antennaHeight = 1.6;
    params.infra.UE.receiverSensitivitydB = -80;
    %% map para
    params.map = struct();
    params.map.file = "./config/Shinjuku.osm";
    % cartesian coordinate system
    params.map.originLatitude = 40.727084;
    params.map.originLongitude = -74.207675;
    params.map.xAxisLat = 40.726903;
    params.map.xAxisLon = -74.20682;

    %% data
    params.file.rays = "./data/raysData.mat";
    params.file.channels = "./data/channelsData.mat"; 
    params.file.channelsAll = "./data/channelsDataAll.mat"; 
    params.file.beamScan = "./data/beamScanData.mat"; 
end