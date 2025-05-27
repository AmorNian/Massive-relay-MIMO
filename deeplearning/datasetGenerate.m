filePath = "./deeplearning/dataset/rawdata.mat"; 
datasetSize = 20000;

addpath(genpath('./'))
rng('shuffle');
params = getParameters();
%viewer = siteviewer("Name","Shinjuku","Basemap","streets","Buildings",params.map.file);
newset = false;
params = createUE(params);                
params = getRaytracing(params,newset);
params = cartesianCoordinate(params);
params = calculateDistance(params);
params = calculateChannels(params,newset);
params = judgeLoSRS(params);
params = getBeamScan(params,newset);