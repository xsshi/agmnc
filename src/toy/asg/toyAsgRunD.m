function wsRun = toyAsgRunD(tagSrc, tagAlg, varargin)
% Run graph matching algorithm on the toy data set.
%
% Input
%   tagSrc   -  source type, 1 | 2 | 3
%   tagAlg   -  algorithm type, 1 | 2 | ...
%   varargin
%     save option
%
% Output
%   wsRun
%     prex   -  name
%     Me     -  mean, nAlg x nBin
%     Dev    -  standard deviation, nAlg x nBin
%     ObjMe  -  mean of objective, nAlg x nBin
%     ObjDev -  standard deviation of objective, nAlg x nBin
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 01-25-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 05-06-2013
%   modify  -  Xiangsheng Shi (xsshi@foxmail.com) 03-09-2024

% save option
prex = cellStr('toy', 'tagSrc', tagSrc, 'tagAlg', tagAlg);
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'run', ...
                   'fold', 'toy/asg/runD');

% load
if svL == 2 && exist(path, 'file')
    wsRun = matFld(path, 'wsRun');
    prInOut('toyAsgRunD', 'old, %s', prex);    
    return;
end
prIn('toyAsgRunD', 'new, %s', prex);

% parameters for generating src
ParSrc = toyAsgPar(tagSrc);

% parameters for algorithm
[parAlgs, algs] = gmPar(tagAlg);

% dimension
[nRep, nBin] = size(ParSrc);
nAlg = length(parAlgs);

% per rep
[Objs, Accs, Recalls] = zeross(nAlg, nBin, nRep);

prCIn('rep', nRep, 1);
for iRep = 1 : nRep
    prC(iRep);
    parSrcs = ParSrc(iRep, :);

    wsRep = toyAsgRunRepD(tagSrc, tagAlg, iRep, 'svL', 2);
    [Objs(:, :, iRep), Accs(:, :, iRep), Recalls(:, :, iRep)] = stFld(wsRep, 'Obj', 'Acc', 'Recall');
end
prCOut(nRep);

% stat
[accMe, recallMe, accDev, recDev, ObjMe, ObjDev] = zeross(nAlg, nBin);
for iBin = 1 : nBin
    Acci = reshape(Accs(:, iBin, :), nAlg, nRep);
    Recalli = reshape(Recalls(:, iBin, :), nAlg, nRep);
    Obji = reshape(Objs(:, iBin, :), nAlg, nRep);
    Obji = Obji ./ repmat(Obji(end, :), nAlg, 1);
    
    % mean & deviation
    accMe(:, iBin) = mean(Acci, 2);
    recallMe(:, iBin) = mean(Recalli, 2);
    accDev(:, iBin) = std(Acci, 0, 2);
    recDev(:, iBin) = std(Recalli, 0, 2);
    ObjMe(:, iBin) = mean(Obji, 2);
    ObjDev(:, iBin) = std(Obji, 0, 2);
end


% store
wsRun.prex = prex;
wsRun.accMe = accMe;
wsRun.recallMe = recallMe;
wsRun.Objs = Objs;
wsRun.accDev = accDev;
wsRun.recDev = recDev;
wsRun.ObjMe = ObjMe;
wsRun.ObjDev = ObjDev;

% save
if svL > 0
    save(path, 'wsRun');
end

prOut;
