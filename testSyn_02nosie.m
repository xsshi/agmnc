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

%% run 2 (noise)
tagSrc = 2;
[~, val2s] = toyAsgPar(tagSrc);
wsRun2 = toyAsgRunD(tagSrc, tagAlg, 'svL', svL);
%[Me2, Dev2, ObjMe2, ObjDev2] = stFld(wsRun2, 'Me', 'Dev', 'ObjMe', 'ObjDev');
[accMe2, recallMe2, accDev2, recDev2, ObjMe2, ObjDev2] = stFld(wsRun2, 'accMe', 'recallMe', 'accDev', 'recDev', 'ObjMe', 'ObjDev');

%% show accuracy & objective
rows = 1; cols = 3;
Ax = iniAx(1, rows, cols, [250 * rows, 250 * cols]);

shCur(accMe2, accDev2, 'ax', Ax{1}, 'dev', 'y');
xticks = 1 : 2 : size(accMe2, 2);
setAxTick('x', '%.2f', xticks, val2s(xticks));
set(gca, 'ylim', [0 1.1], 'ytick', 0 : .2 : 1, 'xlim', [.5, size(accMe2, 2) + .5]);
axis square;
xlabel('Edge deformation', 'FontWeight', 'bold');
ylabel('Accuracy', 'FontWeight', 'bold');
% 
shCur(recallMe2, recDev2, 'ax', Ax{2}, 'dev', 'y');
xticks = 1 : 2 : size(recallMe2, 2);
setAxTick('x', '%.2f', xticks, val2s(xticks));
set(gca, 'ylim', [0 1.1], 'ytick', .0 : .2 : 1, 'xlim', [.5, size(recallMe2, 2) + .5]);
axis square;
xlabel('Edge deformation', 'FontWeight', 'bold');
ylabel('Recall Rate', 'FontWeight', 'bold');

shCur(accMe2, accDev2, 'ax', Ax{3}, 'dev', 'n', 'algs', algs);
set(Ax{3}, 'visible', 'off');

cla;
