% A demo comparison of different graph matching methods on the synthetic dataset.
%
% Remark
%   The edge is directed and the edge feature is asymmetric.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-20-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-07-2013

clear variables;
prSet(1);

%% src parameter
tag = 1; 
nIn = 20; % #inliers
nOuts = [4 4]; % #outliers
egDen = .7; % edge density
egDef = 0; % edge deformation
parKnl = st('alg', 'toy'); % type of affinity: synthetic data

%% algorithm parameter
[pars, algs] = gmPar_syntheticData(2);

%% src
wsSrc = toyAsgSrcD(tag, nIn, nOuts, egDen, egDef);
[gphs, asgT] = stFld(wsSrc, 'gphs', 'asgT');

%% affinity
[KP, KQ] = conKnlGphPQD(gphs, parKnl); % node and edge affinity
K = conKnlGphKD(KP, KQ, gphs); % global affinity
Ct = ones(size(KP)); % mapping constraint (default to a constant matrix of one)

%% directed graph -> undirected graph (for fgmU and PM)
gphUs = gphD2Us(gphs);
[~, KQU] = knlGphKD2U(KP, KQ, gphUs);

%% Truth
asgT.obj = asgT.X(:)' * K * asgT.X(:);
asgT.acc = 1;

%% GA
asgGa = gm(K, Ct, asgT, pars{1}{:});

%% PM
asgPm = pm(K, KQU, gphUs, asgT);

%% SM
asgSm = gm(K, Ct, asgT, pars{3}{:});

%% SMAC
asgSmac = gm(K, Ct, asgT, pars{4}{:});

%% IPFP-S
asgIpfpS = gm(K, Ct, asgT, pars{5}{:});

%% RRWM
asgRrwm = gm(K, Ct, asgT, pars{6}{:});


%% Adaptive Graph Matching (AGM)
asgAgm = agm_syn(K,Ct,asgT, pars{7}{:});

%% Adaptive Graph Matching with Node Centrality (AGMNC)
asgAgmNC = agmnc_syn(K,Ct, gphs,asgT, pars{8}{:});


%% print accuracy and objective
fprintf('Truth : num %.2f\n', sum(asgT.X(:)));
fprintf('GA    : recall %.2f, acc %.2f, obj %.2f\n', asgGa.recall, asgGa.acc, asgGa.obj);
fprintf('PM    : recall %.2f, acc %.2f, obj %.2f\n', asgPm.recall, asgPm.acc, asgPm.obj);
fprintf('SM    : recall %.2f, acc %.2f, obj %.2f\n', asgSm.recall, asgSm.acc, asgSm.obj);
fprintf('SMAC  : recall %.2f, acc %.2f, obj %.2f\n', asgSmac.recall, asgSmac.acc, asgSmac.obj);

fprintf('IPFP-S: recall %.2f, acc %.2f, obj %.2f\n', asgIpfpS.recall, asgIpfpS.acc, asgIpfpS.obj);
fprintf('RRWM  : recall %.2f, acc %.2f, obj %.2f\n', asgRrwm.recall, asgRrwm.acc, asgRrwm.obj);
fprintf('AGM : recall %.2f, acc %.2f, num %.2f\n', asgAgm.recall, asgAgm.acc, sum(asgAgm.X(:)));
fprintf('AGMNC : recall %.2f, acc %.2f, num %.2f\n', asgAgmNC.recall, asgAgmNC.acc, sum(asgAgmNC.X(:)));

% %% show correspondence matrix
% asgs = {asgT, asgGa, asgPm, asgSm, asgSmac, asgIpfpU, asgIpfpS, asgRrwm, asgFgmU, asgFgmD};
% rows = 2; cols = 5;
% Ax = iniAx(1, rows, cols, [250 * rows, 250 * cols]);
% shAsgX(asgs, Ax, ['Truth' algs]);
