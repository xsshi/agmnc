% Testing the performance of different graph matching methods on the toy dataset.
% This is a similar function used for reporting (Fig. 4) the first experiment (Sec 5.1) in the CVPR 2012 paper.
%
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 09-01-2012
%   modify   -  Feng Zhou (zhfe99@gmail.com), 05-08-2013
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 05-29-2024

clear variables;
prSet(4);

%% save flag
svL = 2; % change svL = 1 if you want to re-run the experiments.

%% algorithm parameter
tagAlg = 2;
[~, algs] = gmPar_syntheticData(tagAlg);

% run 1 (outliers)
tagSrc = 1;
[~, val1s] = toyAsgPar(tagSrc);
wsRun1 = toyAsgRunD(tagSrc, tagAlg, 'svL', svL);
% %[Me1, Dev1, ObjMe1, ObjDev1] = stFld(wsRun1, 'Me', 'Dev', 'ObjMe', 'ObjDev');
[accMe1, recallMe1, accDev1, recDev1, ObjMe1, ObjDev1] = stFld(wsRun1, 'accMe', 'recallMe', 'accDev', 'recDev', 'ObjMe', 'ObjDev');


%% show accuracy & objective
rows = 1; cols = 3;
Ax = iniAx(1, rows, cols, [250 * rows, 250 * cols]);

shCur(accMe1, accDev1, 'ax', Ax{1}, 'dev', 'y');
xticks = 1 : 2 : size(accMe1, 2);
setAxTick('x', '%d', xticks, val1s(xticks));
set(gca, 'ylim', [0 1.1], 'ytick', 0 : .2 : 1, 'xlim', [.5, size(accMe1, 2) + .5]);
axis square;
xlabel('Outlier', 'FontWeight', 'bold');
ylabel('Accuracy', 'FontWeight', 'bold');

shCur(recallMe1, recDev1, 'ax', Ax{2}, 'dev', 'y');
xticks = 1 : 3 : size(recallMe1, 2);
setAxTick('x', '%d', xticks, val1s(xticks));
set(gca, 'ylim', [.27 1.05], 'ytick', .2 : .2 : 1, 'xlim', [.5, size(recallMe1, 2) + .5]);
axis square;
xlabel('Outlier', 'FontWeight', 'bold');
ylabel('Recall Rate', 'FontWeight', 'bold');

shCur(accMe1, accDev1, 'ax', Ax{3}, 'dev', 'n', 'algs', algs);
set(Ax{3}, 'visible', 'off');

cla;
