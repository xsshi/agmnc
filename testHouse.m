% Testing the performance of different graph matching methods on the CMU House dataset.
% This is the same function used for reporting (Fig. 4) the first experiment (Sec 5.1) in the CVPR 2013 paper.
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 09-01-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 05-08-2013
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 05-29-2024

clear variables;
prSet(4);

%% save flag
svL = 1; % change svL = 1 if you want to re-run the experiments.

%% algorithm parameter
tagAlg = 2;
[~, algs] = gmPar(tagAlg);

%% run 1 (perfect graphs, no noise)
% tagSrc = 1;
% [~, val1s] = cmumAsgPair(tagSrc);
% wsRun1 = cmumAsgRun(tagSrc, tagAlg, 'svL', svL);
% [accMe1, recallMe1, accDev1, recDev1, ObjMe1, ObjDev1] = stFld(wsRun1, 'accMe', 'recallMe', 'accDev', 'recDev', 'ObjMe', 'ObjDev');

%% run 2 (randomly remove nodes)
tagSrc = 2;
[~, val2s] = cmumAsgPair(tagSrc);
wsRun2 = cmumAsgRun(tagSrc, tagAlg, 'svL', svL);
[accMe2, recallMe2, accDev2, recDev2, ObjMe2, ObjDev2] = stFld(wsRun2, 'accMe', 'recallMe', 'accDev', 'recDev', 'ObjMe', 'ObjDev');

%% show accuracy, recall rate & objective
rows = 1; cols = 3;
Ax = iniAx(1, rows, cols, [250 * rows, 250 * cols]);

shCur(accMe2, accDev2, 'ax', Ax{1}, 'dev', 'y');
xticks = 1 : 3 : size(accMe2, 2);
setAxTick('x', '%d', xticks, val2s(xticks));
set(gca, 'ylim', [.27 1.05], 'ytick', .4 : .2 : 1, 'xlim', [.5, size(accMe2, 2) + .5]);
axis square;
xlabel('baseline', 'FontWeight', 'bold');
ylabel('Accuracy', 'FontWeight', 'bold');

shCur(recallMe2, recDev2, 'ax', Ax{2}, 'dev', 'y');
xticks = 1 : 3 : size(recallMe2, 2);
setAxTick('x', '%d', xticks, val2s(xticks));
set(gca, 'ylim', [.27 1.05], 'ytick', .2 : .2 : 1, 'xlim', [.5, size(recallMe2, 2) + .5]);
axis square;
xlabel('baseline', 'FontWeight', 'bold');
ylabel('Recall Rate', 'FontWeight', 'bold');

shCur(accMe2, accDev2, 'ax', Ax{3}, 'dev', 'n', 'algs', algs);
set(Ax{3}, 'visible', 'off');

cla;
