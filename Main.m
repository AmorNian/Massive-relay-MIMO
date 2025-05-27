%% Simulator
tic
addpath(genpath('./'))
%rng('shuffle');
rng(1106);
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

% userSchedulingMethod = @randomUserScheduling;
% otherparamsUS = [6,6,6];
% params = userScheduling(userSchedulingMethod, params, otherparamsUS);

% userSchedulingMethod = @simulatedAnnealingUserScheduling;
% otherparamsUS = [6,6,6];
% params = userScheduling(userSchedulingMethod, params, otherparamsUS);
% 
% resourceAllocationMethod = @randomResourceAllocation;
% RApattern = {[2,2,2],[2,2,2],[2,2,2]};
% otherParamsRA = {RApattern,"SA"};
% params = resourceAllocation(resourceAllocationMethod, params, otherParamsRA);

% userSchedulingMethod = @maxMinUserScheduling;
% ifRL = true;
% otherparamsUS = {[6,6,6], ifRL};
% params = userScheduling(userSchedulingMethod, params, otherparamsUS);

userSchedulingMethod = @singleUserScheduling;
ifRL = true;
otherparamsUS = ifRL;
params = userScheduling(userSchedulingMethod, params, otherparamsUS);

relaySelectionMethod = @LoSRSBasedRelaySelection;
otherParamsRS = {"resourceAllocation","single"};
params = relaySelection(relaySelectionMethod, params, otherParamsRS);
% checkBeamConflict(params)
params = calculateCapacity(params,"single");
%close(viewer)
toc
disp("sum:")
disp(sum(params.capacity.channelCapacity))