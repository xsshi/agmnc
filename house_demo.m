clear variables;
prSet(1); % Set the promption level.

%% src parameter
tag = 'house';
pFs = [1 100]; % frame index
nIn = [30 30]-[8 8]; % randomly remove 10 nodes
parKnl = st('alg', 'cmum'); % type of affinity: only edge distance % st.m Create a struct.
%parKnl is a struct that: parKnl.alg = 'cmum'

%% algorithm parameter
[pars, algs] = gmPar(2); % Obtain parameters for graph matching algorithm.
% Input
%   tag     -  type of pair, 1 | 2 
%                1 : ga, sm, smac, ipfp1, ipfp2, rrwm, fgmU
%                2 : ga, sm, smac, ipfp1, ipfp2, rrwm, fgmU, fgmD
%
% Output
%   pars    -  parameters for each algorithm, 1 x nAlg (cell), 1 x nPari (cell)
%   algs    -  algorithm name, 1 x nAlg (cell)
%pars and algs are 1*100 cell matrices and first several cells contain ga, sm, smac, ipfp1,
%ipfp2, rrwm, fgmU, fgmD's parameters.  'parIni, parPosC, parPosD'(are st.m constructed)


%% src
wsSrc = cmumAsgSrc(tag, pFs, nIn, 'svL', 1); %cmumAsgSrc.m Generate CMU Motion source for assignment problem.
asgT = wsSrc.asgT; %true assign

%% feature
parG = st('link', 'del'); % Delaunay triangulation for computing the graphs % parG Graph Parameter
parF = st('smp', 'n', 'nBinT', 4, 'nBinR', 3); % not used, ignore it % parF Feature Parameter
wsFeat = cmumAsgFeat(wsSrc, parG, parF, 'svL', 1); %cmumAsgFeat.m Obtain the feature of CMU Motion for assignment problem.
[gphs, XPs, Fs] = stFld(wsFeat, 'gphs', 'XPs', 'Fs'); %stFld.m Fetch out the field value according to the specific field name list.


%% affinity
[KP, KQ] = conKnlGphPQU(gphs, parKnl);%conKnlGphPQU.m Compute node and feature affinity matrix for graph matching.
K = conKnlGphKU(KP, KQ, gphs);
Ct = ones(size(KP));

%% undirected graph -> directed graph (for FGM-D)
gphDs = gphU2Ds(gphs);
KQD = [KQ, KQ; KQ, KQ];

%% GA
asgGa = gm(K, Ct, asgT, pars{1}{:});

%% PM
asgPm = pm(K, KQ, gphs, asgT);

%% SM
asgSm = gm(K, Ct, asgT, pars{3}{:});

%% SMAC
asgSmac = gm(K, Ct, asgT, pars{4}{:});


%% IPFP-S
asgIpfpS = gm(K, Ct, asgT, pars{5}{:});

%% RRWM
asgRrwm = gm(K, Ct, asgT, pars{6}{:});

%% Adaptive Graph Matching (AGM)
asgAgm = agm(K,Ct,asgT, pars{7}{:});

%% Adaptive Graph Matching with Node Centrality (AGMNC)
asgAgmNC = agmnc(K,Ct, gphs,asgT, pars{8}{:});


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

%% print
% %% print information
% fprintf('GA    : acc %.2f, obj %.2f\n', asgGa.acc, asgGa.obj);
% fprintf('PM    : acc %.2f, obj %.2f\n', asgPm.acc, asgPm.obj);
% fprintf('SM    : acc %.2f, obj %.2f\n', asgSm.acc, asgSm.obj);
% fprintf('SMAC  : acc %.2f, obj %.2f\n', asgSmac.acc, asgSmac.obj);
% fprintf('IPFP-U: acc %.2f, obj %.2f\n', asgIpfpU.acc, asgIpfpU.obj);
% fprintf('IPFP-S: acc %.2f, obj %.2f\n', asgIpfpS.acc, asgIpfpS.obj);
% fprintf('RRWM  : acc %.2f, obj %.2f\n', asgRrwm.acc, asgRrwm.obj);
% fprintf('FGM-U : acc %.2f, obj %.2f\n', asgFgmU.acc, asgFgmU.obj);
% fprintf('FGM-D : acc %.2f, obj %.2f\n', asgFgmD.acc, asgFgmD.obj);
% 
% %% show correspondence result
% rows = 1; cols = 1;
% Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
% parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
% shAsgImg(Fs, gphs, asgFgmD, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
% title('result of FGM-D');
% 
% %% show affinity
% rows = 1; cols = 3;
% Ax = iniAx(2, rows, cols, [200 * rows, 200 * cols]);
% shAsgK(K, KP, KQ, Ax);
% 
% %% show correpsondence matrix
% asgs = {asgT, asgGa, asgPm, asgSm, asgSmac, asgIpfpU, asgIpfpS, asgRrwm, asgFgmU, asgFgmD};
% rows = 2; cols = 5;
% Ax = iniAx(3, rows, cols, [250 * rows, 250 * cols]);
% shAsgX(asgs, Ax, ['Truth', algs, 'FGM-A']);

% show correspondence result
% rows = 1; cols = 1;
% Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
% parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
% shAsgImg(Fs, gphs, asgPm, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
% title('result of GA');
% 
% rows = 1; cols = 1;
% Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
% parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
% shAsgImg(Fs, gphs, asgPm, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
% title('result of PM');
% 
% rows = 1; cols = 1;
% Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
% parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
% shAsgImg(Fs, gphs, asgSmac, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
% title('result of SMAC');
% rows = 1; cols = 1;
% 
% Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
% parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
% shAsgImg(Fs, gphs, asgRrwm, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
% title('result of RRWM');
% 
rows = 1; cols = 1;
Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
shAsgImg(Fs, gphs, asgAgm, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
title('result of AGM', 'FontSize', 18);
% 
rows = 1; cols = 1;
Ax = iniAx(1, rows, cols, [400 * rows, 900 * cols], 'hGap', .1, 'wGap', .1);
parCor = st('cor', 'ln', 'mkSiz', 7, 'cls', {'y', 'b', 'g'});
shAsgImg(Fs, gphs, asgAgmNC, asgT, parCor, 'ax', Ax{1}, 'ord', 'n');
title('result of Ours', 'FontSize', 18);
