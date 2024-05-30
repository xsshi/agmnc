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

%% run 3 (Edge density)
tagSrc = 3;
[~, val3s] = toyAsgPar(tagSrc);
wsRun3 = toyAsgRunD(tagSrc, tagAlg, 'svL', svL);
% %[Me3, Dev3, ObjMe3, ObjDev3] = stFld(wsRun3, 'Me', 'Dev', 'ObjMe', 'ObjDev');
[accMe3, recallMe3, accDev3, recDev3, ObjMe3, ObjDev3] = stFld(wsRun3, 'accMe', 'recallMe', 'accDev', 'recDev', 'ObjMe', 'ObjDev');

%% show accuracy & objective
rows = 1; cols = 3;
Ax = iniAx(1, rows, cols, [250 * rows, 250 * cols]);


shCur(accMe3, accDev3, 'ax', Ax{1}, 'dev', 'y');
xticks = 1 : 2 : size(accMe3, 2);
setAxTick('x', '%.1f', xticks, val3s(xticks));
set(gca, 'ylim', [0 1.1], 'ytick', 0 : .2 : 1, 'xlim', [.5, size(accMe3, 2) + .5]);
axis square;
xlabel('Edge density', 'FontWeight', 'bold', 'FontSize', 16);
ylabel('Accuracy', 'FontWeight', 'bold', 'FontSize', 16);

shCur(recallMe3, recDev3, 'ax', Ax{2}, 'dev', 'y');
xticks = 1 : 2 : size(recallMe3, 2);
setAxTick('x', '%.1f', xticks, val3s(xticks));
set(gca, 'ylim', [.27 1.05], 'ytick', .2 : .2 : 1, 'xlim', [.5, size(recallMe3, 2) + .5]);
axis square;
xlabel('Edge density', 'FontWeight', 'bold', 'FontSize', 16);
ylabel('Recall Rate', 'FontWeight', 'bold', 'FontSize', 16);


shCur(accMe3, accDev3, 'ax', Ax{3}, 'dev', 'n', 'algs', algs);
set(Ax{3}, 'visible', 'off');

cla;
